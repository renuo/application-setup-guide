import * as Sentry from '@sentry/browser';

Sentry.init(window.sentryConfig);
window.Sentry = Sentry;
