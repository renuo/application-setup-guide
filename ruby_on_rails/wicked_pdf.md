# Wicked PDF

Can be used to generate PDFs and supports HTML to PDF.

> :warning: Up to now, Wicked PDF does not support Bootstrap 4, so if you want to use Bootstrap 4 Templates, use another library.

* Add `gem 'wicked_pdf'` to the main section of `Gemfile`
* Add `gem 'wkhtmltopdf-binary'` to `group :development, :test`
* Add `gem 'wkhtmltopdf-heroku'` to `group :production`

By default, it adds no layout, you you may want to add a layout:

* Create a `pdf.pdf.erb`
* Use the method to add stylesheets : `wicked_pdf_stylesheet_link_tag 'pdf', media: 'all'`
* Use the method `wicked_pdf_image_tag` to insert images to the layout.

*Usage:*

```rb
render pdf: <<filename>>, print_media_type: true, layout: 'pdf', disposition: 'attachment'
```

> :warning: Consider using a job-runner to not block the server during creation of PDFs.

## Heroku

Ensure that fonts are installed on Heroku, otherwise the PDF will look different compared to the one generated locally. The fonts need to be installed with a buildpack and put in the `~/.fonts` folder.
If you need Arial, you can add the following buildpack on Heroku:

`https://github.com/propertybase/heroku-buildpack-fonts`

> :warning: Make sure you add this as a first buildpack before `heroku/ruby`!
