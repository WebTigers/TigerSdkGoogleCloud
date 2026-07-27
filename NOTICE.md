# NOTICE

**Tiger Google Cloud PHP SDK** (`webtigers/tiger-sdk-googlecloud`) is licensed MIT — see [LICENSE](LICENSE). "Tiger" and "WebTigers"
are trademarks of WebTigers.

This module is a **repackaging convenience**: its released bundle vendors third-party software so a
Tiger install can use Google Cloud Storage without running Composer. That bundled software keeps its own
license, which governs its use:

- **google/cloud-storage** (Apache-2.0) — https://github.com/googleapis/google-cloud-php-storage
- its transitive dependencies (Guzzle, PSR interfaces, etc.), each under its own license.

The complete, authoritative license text for every bundled package ships **unmodified** inside the
release bundle under `vendor/<vendor>/<package>/LICENSE`. This module only vendors and autoloads that
code; no bundled source is altered. Refer to each package's own repository for its canonical terms.
