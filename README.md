journaldriver
=============

This is a small daemon used to forward logs from `journald` (systemd's
logging service) to [Stackdriver Logging][].

Many existing log services are written in inefficient dynamic
languages with error-prone "cover every possible use-case"
configuration. `journaldriver` instead aims to fit a specific use-case
very well, instead of covering every possible logging setup.

This fork of `journaldriver` is designed to run outside of GCP

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [Features](#features)
- [Usage outside of Google Cloud Platform](#usage-outside-of-google-cloud-platform)
- [Log levels / severities / priorities](#log-levels--severities--priorities)
- [NixOS module](#nixos-module)
- [Stackdriver Error Reporting](#stackdriver-error-reporting)

<!-- markdown-toc end -->

# Features

* `journaldriver` persists the last forwarded position in the journal
  and will resume forwarding at the same position after a restart
* `journaldriver` will recognise log entries in JSON format and
  forward them appropriately to make structured log entries available
  in Stackdriver
* `journaldriver` can be used outside of GCP by configuring static
  credentials
* `journaldriver` will recognise journald's log priority levels and
  convert them into equivalent Stackdriver log severity levels

# Usage outside of Google Cloud Platform

When running outside of GCP, the following extra steps need to be
performed:

1. Create a Google Cloud Platform service account with the "Log
   Writer" role and download its private key in JSON-format.
2. When starting `journaldriver`, configure the following environment
   variables:

   * `GOOGLE_CLOUD_PROJECT`: Name of the GCP project to which logs
     should be written.
   * `GOOGLE_APPLICATION_CREDENTIALS`: Filesystem path to the
     JSON-file containing the service account's private key.
   * `LOG_NAME`: Name of the target log to write to. This defaults to
     `journaldriver` if unset, but it is recommended to - for
     example - set it to the machine hostname.

# Log levels / severities / priorities

`journaldriver` recognises [journald's priorities][] and converts them
into [equivalent severities][] in Stackdriver. Both sets of values
correspond to standard `syslog` priorities.

The easiest way to emit log messages with priorites from an
application is to use [priority prefixes][], which are compatible with
structured log messages.

For example, to emit a simple warning message (structured and
unstructured):

```
$ echo '<4>{"fnord":true, "msg":"structured log (warning)"}' | systemd-cat
$ echo '<4>unstructured log (warning)' | systemd-cat
```

[Stackdriver Logging]: https://cloud.google.com/logging/
[Google's documentation]: https://cloud.google.com/logging/docs/access-control
[contains a module]: https://github.com/NixOS/nixpkgs/pull/42134
[journald's priorities]: http://0pointer.de/public/systemd-man/sd-daemon.html
[equivalent severities]: https://cloud.google.com/logging/docs/reference/v2/rest/v2/LogEntry#logseverity
[priority prefixes]: http://0pointer.de/public/systemd-man/sd-daemon.html
[Stackdriver Error Reporting]: https://cloud.google.com/error-reporting/
[log format]: https://cloud.google.com/error-reporting/docs/formatting-error-messages
[issue #4]: https://github.com/tazjin/journaldriver/issues/4
