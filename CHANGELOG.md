# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2025-11-23

### Added
- Comprehensive RSpec test suite
- SimpleCov integration for test coverage tracking
- README.md with comprehensive documentation
- CHANGELOG.md following Keep a Changelog format

### Changed
- Improved code safety by using `options.dup.tap` in `rails_panda__add_ui_language_to` to avoid mutating input hashes
- `rails_panda__get_user_locale` now consistently returns symbols for locales
- `rails_panda__add_ui_language_to` now returns the options hash (or duplicated version) even when param support is disabled, instead of returning `nil`

### Fixed
- Fixed module scoping issues by using `::I18n` to correctly reference the global I18n module
- Fixed return value consistency when param support is disabled

## [1.0.6] - 2025-10-06

### Changed
- Renamed gem from `definerails-i18n` to `rails-panda-i18n`
- Moved from Rubocop to StandardRb for code style enforcement
- Fixed loading issues - gem now loads correctly
- Added frozen string literal comments to all files

### Fixed
- Fixed module loading and initialization issues

## [1.0.5] - 2025-08-09

### Fixed
- Corrected a breaking bug

## [1.0.4] - 2025-07-10

### Fixed
- Corrected problems that would occur if cookies and/or params were not used

## [1.0.2] - 2022-05-01

### Added
- Added LICENSE file

### Changed
- Updated Gemfile dependencies
- Cleaned up Rakefile and tasks
- Updated gemspec

## [1.0.1.3] - 2019-08-20

### Changed
- Minor updates and improvements

## [1.0.1.2] - 2016-07-08

### Fixed
- Corrected bug with `http_accept_language` not being loaded

## [1.0.1.1] - 2016-02-01

### Added
- Added more configurability options

## [1.0.0] - 2015-11-10

### Added
- Initial release
- Basic locale detection from URL parameters and cookies
- Automatic locale setting via `before_action`
- URL helper integration
- Cookie persistence
- HTTP Accept-Language header fallback support

[Unreleased]: https://github.com/bigbadpanda-tech/rails-panda-i18n/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/bigbadpanda-tech/rails-panda-i18n/compare/v1.0.6...v1.1.0
[1.0.6]: https://github.com/bigbadpanda-tech/rails-panda-i18n/compare/v1.0.5...v1.0.6
[1.0.5]: https://github.com/bigbadpanda-tech/rails-panda-i18n/compare/v1.0.4...v1.0.5
[1.0.4]: https://github.com/bigbadpanda-tech/rails-panda-i18n/compare/v1.0.2...v1.0.4
[1.0.2]: https://github.com/bigbadpanda-tech/rails-panda-i18n/compare/v1.0.1.3...v1.0.2
[1.0.1.3]: https://github.com/bigbadpanda-tech/rails-panda-i18n/compare/v1.0.1.2...v1.0.1.3
[1.0.1.2]: https://github.com/bigbadpanda-tech/rails-panda-i18n/compare/v1.0.1.1...v1.0.1.2
[1.0.1.1]: https://github.com/bigbadpanda-tech/rails-panda-i18n/compare/v1.0.0...v1.0.1.1
[1.0.0]: https://github.com/bigbadpanda-tech/rails-panda-i18n/releases/tag/v1.0.0
