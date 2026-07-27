# Tiger Google Cloud PHP SDK (`webtigers/tiger-sdk-googlecloud`)

A **Tiger provider module** that vendors [`google/cloud-storage`](https://github.com/googleapis/google-cloud-php-storage) so a Tiger install can use
**Google Cloud Storage** media storage **without running Composer on the server** — the shared-hosting / cPanel
case.

It ships **no controllers, routes, or views**. Its only job is to register the bundled SDK's autoloader
(see [`Bootstrap.php`](Bootstrap.php)) so the classes the core Google Cloud Storage storage adapter needs resolve
while the module is active.

## Install

Use the Tiger **Module Manager** (Add module → from the directory or a URL) and activate. Then choose
**Google Cloud Storage** under *Settings → Media → Storage* and **Test connection**.

## One cloud SDK at a time

This module declares a `conflict` with the other cloud SDK providers in [`module.json`](module.json).
Activating one cloud SDK auto-deactivates the others (with a confirm), because loading two would load two
copies of the shared HTTP library. Most installs use a single cloud backend.

## How the bundle is built

The repo does **not** commit `vendor/` — it's a **release artifact**. CI
([`.github/workflows/release.yml`](.github/workflows/release.yml)) runs
[`bin/build-bundle.sh`](bin/build-bundle.sh), which resolves the latest `google/cloud-storage` + dependencies, stamps
`module.json`'s version to the exact SDK version, zips the module (with the resolved `vendor/`), and cuts
a GitHub release tagged with that version — **one bundle per module, tracking upstream**.

## License

MIT (this module) — see [LICENSE](LICENSE). Bundled third-party licenses are catalogued in
[NOTICE.md](NOTICE.md).
