# Wallee

## Payment Page

### Setup Wallee

1. Visit [Wallee](https://app-wallee.com/).
2. Go to `Account` -> `Application User`, create a new user and store the credentials.
3. Go to `Space` -> `Settings` -> `Payment` and setup a new processor. Choose `Bogus Processor` for testing.

### Configure Rails

1. Use the [`wallee-ruby-sdk`](https://github.com/wallee-payment/ruby-sdk) gem to interact with the Wallee API.

   ```ruby
   # Gemfile

   gem 'wallee-ruby-sdk'
   ```

2. Configure the credentials

   ```ruby
   # config/initializers/wallee.rb

   Wallee.configure do |config|
     config.user_id = ENV.fetch("WALLEE_APP_USER_ID")
     config.authentication_key = ENV.fetch("WALLEE_APP_AUTHENTICATION_KEY")
   end
   ```

3. Add a tool class to create a payment page URL.
   Be aware that this is very simple tooling.

   ```ruby
   # app/models/wallee/payment_page.rb

   module Wallee
     class PaymentPage
       SPACE_ID = ENV.fetch("WALLEE_SPACE_ID")

       # Simplest Payment integration I could think of.
       # Attention: Check VAT, shipping address and shipping method
       #
       # @example
       #   Wallee::PaymentPage.url_for(
       #     cart: [
       #       {name: "Eintritt Erwachsene", sku: "adult_entry", price: 30, quantity: 2}
       #     ],
       #     address: {
       #       city: "Zürich",
       #       country: "CH",
       #       email_address: "customer@example.com",
       #       family_name: "Muster",
       #       given_name: "Hans",
       #       postcode: "8000",
       #       street: "Musterstrasse 1"
       #     }
       #   ) do |transaction|
       #     # Save transaction.id to the order
       #   end
       def self.url_for(cart:, address:, reference:, success_url: nil, failed_url: nil, &)
         raise "Cart is empty" if cart.empty?
         raise "Bad cart format" unless cart.all? { |item| item.keys == [:name, :sku, :price, :quantity] }

         line_items = cart.map.with_index do |item, index|
           Wallee::LineItemCreate.new({
             amountIncludingTax: item[:price] * item[:quantity],
             name: item[:name],
             quantity: item[:quantity],
             shippingRequired: true,
             sku: item[:sku],
             taxes: [Wallee::TaxCreate.new({rate: 0, title: "VAT"})],
             type: Wallee::LineItemType::PRODUCT,
             uniqueId: "#{item[:sku]}-#{index}"
           })
         end

         billing_address = shipping_address = Wallee::AddressCreate.new(
           city: address[:city],
           country: address[:country],
           emailAddress: address[:email_address],
           familyName: address[:family_name],
           givenName: address[:given_name],
           postcode: address[:postcode],
           street: address[:street]
         )

         transaction_create = Wallee::TransactionCreate.new({
           billingAddress: billing_address,
           currency: "CHF",
           customerPresence: Wallee::CustomersPresence::VIRTUAL_PRESENT,
           failedUrl: failed_url,
           language: "de_CH",
           lineItems: line_items,
           merchantReference: reference,
           shippingAddress: shipping_address,
           shippingMethod: "Brief A-Post",
           successUrl: success_url
         })

         transaction_service = Wallee::TransactionService.new
         transaction = transaction_service.create(SPACE_ID, transaction_create)
         Rails.logger.info "Wallee transaction created for #{reference}, see #{admin_url(transaction.id)}"

         yield transaction.freeze if block_given?

         transaction_payment_page_service = Wallee::TransactionPaymentPageService.new
         transaction_payment_page_service.payment_page_url(SPACE_ID, transaction.id)
       end

       def self.admin_url(transaction_id)
         "https://app-wallee.com/s/#{SPACE_ID}/payment/transaction/view/#{URI.encode_uri_component transaction_id}"
       end
     end
   end
   ```

4. Add the tests

   ```ruby
   # spec/models/wallee/payment_page_spec.rb

   require "rails_helper"

   RSpec.describe Wallee::PaymentPage do
     describe ".url_for" do
       subject(:url_for) { described_class.url_for(cart: cart, address: address, reference: "my-transaction") }

       context "when cart is empty" do
         let(:cart) { [] }
         let(:address) { double }

         it "raises an error" do
           expect { url_for }.to raise_error("Cart is empty")
         end
       end

       context "when cart is in bad format" do
         let(:cart) { [{blub: 30, quantity: 2}] }
         let(:address) { double }

         it "raises an error" do
           expect { url_for }.to raise_error("Bad cart format")
         end
       end

       context "when cart is valid", vcr: "wallee/payment_url_success" do
         let(:cart) do
           [
             {name: "Eintritt Erwachsene", sku: "adult_entry", price: 30, quantity: 2},
             {name: "Eintritt 16-24 J.", sku: "child_6_10_entry", price: 24, quantity: 1},
             {name: "Eintritt 11-15 J.", sku: "child_11_15_entry", price: 18, quantity: 0},
             {name: "Eintritt 3-10 J.", sku: "child_16_24_entry", price: 10, quantity: 1},
             {name: "Gutscheinkarte", sku: "free_coupon", price: 50, quantity: 1}
           ]
         end

         let(:address) do
           {
             city: "Zürich",
             country: "CH",
             email_address: "customer@example.com",
             family_name: "Muster",
             given_name: "Hans",
             postcode: "8000",
             street: "Musterstrasse 1"
           }
         end

         it { is_expected.to match(URI::DEFAULT_PARSER.make_regexp(["https"])) }

         context "when given a block" do
           it "yields a transaction" do
             expect { |b| described_class.url_for(cart: cart, address: address, reference: "1", &b) }.to yield_with_args(Wallee::Transaction)
           end
         end
       end
     end

     describe ".admin_url" do
       it "generates an admin url for a transaction" do
         expect(described_class.admin_url("1337")).to match(URI::DEFAULT_PARSER.make_regexp(["https"]))
       end

       it "escapes transaction id" do
         expect(described_class.admin_url("#")).to include("%23")
       end
     end
   end
   ```

5. Redirect to the payment page in your controller

   ```ruby
   redirect_to Wallee::PaymentPage.url_for(…) do |transaction|
     # Save transaction.id to the order or whatever you need
   end
   ```

6. **You're done.** You can receive money now if you setup a real payment processor.
   Customers can receive emails directly from Wallee and you can print shipping labels from the Wallee backend.

## Fulfillment via Webhook in Rails

Often a payment page is not enough. You need to know the payment state in your Rails app.
You can either poll the Wallee API or use a webhook. Here's an example of a webhook controller.
Be aware that this is quite integrated with the business logic of your app, e.g. see the `ShopOrder` model.

1. Add the route

   ```ruby
   # config/routes.rb

   post "shop/wallee_webhook", to: "shop#wallee_webhook"
   ```

2. Add the controller

   ```ruby
   # app/controllers/shop_controller.rb

   class ShopController < ApplicationController
     def wallee_webhook
       request_payload = request.body.read
       signature = request.env["HTTP_X_SIGNATURE"]

       if signature.blank?
         Rails.logger.info "Signature missing"
         head :bad_request and return
       end

       webhook_encryption_service = Wallee::WebhookEncryptionService.new
       unless webhook_encryption_service.is_content_valid(signature, request_payload)
         Rails.logger.info "Webhook signature invalid"
         head :bad_request and return
       end

       entity_type, entity_id = JSON.parse(request_payload).slice("listenerEntityTechnicalName", "entityId").values
       if entity_type == "Transaction"
         transaction_service = Wallee::TransactionService.new
         transaction = transaction_service.read(ENV.fetch("WALLEE_SPACE_ID"), entity_id)

         order = ShopOrder.find_by!(wallee_transaction_id: transaction.id)
         order.update!(wallee_transaction_state: transaction.state)
       else
         Rails.logger.info "Unknown entity type: #{entity_type}"
         head :bad_request
       end
     end
   end
   ```

3. Add the tests

   ```ruby
   require "rails_helper"

   RSpec.describe ShopController do
     describe "#wallee_webhook" do
       context "when signature is not valid" do
         it "returns http bad request" do
           post wallee_webhook_path, as: :json
           expect(response).to have_http_status(:bad_request)
         end
       end

       # Set wallee_transaction_id to something which exists on Wallee before rerecording this cassette
       context "when signature is valid", vcr: "wallee/webhook_success" do
         before do
           allow_any_instance_of(Wallee::WebhookEncryptionService).to receive(:is_content_valid).and_return(true)
         end

         let(:wallee_transaction_id) { "194681414" }

         it "goes the happy path" do
           create(:shop_order,  wallee_transaction_id: wallee_transaction_id)
           post wallee_webhook_path,
             env: {"HTTP_X_SIGNATURE" => "fake"},
             params: {listenerEntityTechnicalName: "Transaction", entityId: wallee_transaction_id},
             as: :json

           expect(response).to have_http_status(:success)
         end
       end

       describe "order update" do
         before do
           allow_any_instance_of(Wallee::WebhookEncryptionService).to receive(:is_content_valid).and_return(true)
           allow_any_instance_of(Wallee::TransactionService).to receive(:read).and_return(instance_double(Wallee::Transaction, id: "194681414", state: wallee_transaction_state))
           create(:shop_order, wallee_transaction_id: wallee_transaction_id, wallee_transaction_state: "PENDING")
         end

         let(:order) { ShopOrder.find_by(wallee_transaction_id: "194681414") }
         let(:webhook_request) do
           post wallee_webhook_path,
             env: {"HTTP_X_SIGNATURE" => "fake"},
             params: {listenerEntityTechnicalName: "Transaction", entityId: "194681414"},
             as: :json
         end

         context "when transaction has failed" do
           let(:wallee_transaction_state) { Wallee::TransactionState::FAILED }

           it "updates the order" do
             expect { webhook_request }.to change { order.reload.wallee_transaction_state }.from("PENDING").to("FAILED")
           end

           it "does not fulfill" do
             expect(ApplicationMailer).not_to receive(:order_confirmation_mail).and_call_original
             webhook_request
           end
         end

         context "when transaction is complete" do
           let(:wallee_transaction_state) { Wallee::TransactionState::FULFILL }

           it "updates the order" do
             expect { webhook_request }.to change { order.reload.wallee_transaction_state }.from("PENDING").to("FULFILL")
           end

           it "does fulfill" do
             expect(ApplicationMailer).to receive(:order_confirmation_mail).and_call_original
             webhook_request
           end
         end
       end
     end
   end
   ```

4. … and you're far from done. You need to handle errors, other state changes, and so on. But this is a good start.
5. Oh, and you need to setup the webhook in the Wallee backend, so that it actually sends requests to your Rails app.
