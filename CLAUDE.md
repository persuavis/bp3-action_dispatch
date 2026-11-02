# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

bp3-action_dispatch adapts `ActionDispatch::Request` for BP3 (persuavis/black_phoebe_3), a multi-site
multi-tenant Rails application. It teaches every request which host it was made to, which site that host
belongs to, and which locale it asks for. It also holds the application's site class name, which other
bp3 gems (bp3-noticed, bp3-friendly_id) read through `Bp3::ActionDispatch.site_class`.

## Commands

The gems run on Ruby 3.4.6 (`.ruby-version`). Prefix commands with `~/.rvm/bin/rvm 3.4.6 do` when the
shell is not already on it; a missing `rspec` means the wrong Ruby, not a missing bundle.

- `bundle exec rake` - specs and RuboCop (the default task)
- `bundle exec rspec spec/path/to/file_spec.rb[:LINE]` - one file or example
- `bundle exec rubocop` / `bundle exec rubocop -a`
- `bin/setup`, `bin/console`, `rake install`

## Architecture

`lib/bp3/action_dispatch/railtie.rb` reopens `ActionDispatch::Request` in an `after_initialize` block and
includes three modules. The Railtie is only defined when `Rails.env` is, so the specs load the modules
without Rails.

**RequestHost** (`request_host.rb`)
- `normalized_host`: the request's `host`, which Rails reads from `X-Forwarded-Host` when it is there.
- `request_site`: `Sites::Site.find_host(normalized_host)`, memoized. Depends on RequestHost. It names
  `Sites::Site` directly rather than going through `site_class`

**RequestLocale** (`request_locale.rb`)
- `request_locale`, memoized, tries in order: the first path segment, `params[:locale]`, the host's last
  label (TLD), the `Accept-Language` header (by quality), the site's `configs.locale`, `I18n.default_locale`
- Only locales in `I18n.available_locales` count. `en-us` becomes `:"en-US"`
- `locale_from` records which source won (`'path'`, `'params'`, `'host'`, `'header'`, `'setting'`, `'default'`)

**Configuration** (`lib/bp3/action_dispatch.rb`)
- `Bp3::ActionDispatch.site_class_name`, set in the application's `config/initializers/bp3-action_dispatch.rb`
  to `'Sites::Site'`; `.site_class` constantizes and caches it

## Testing

`spec/bp3/action_dispatch/request_locale_spec.rb` includes `RequestLocale` in a plain test class with
`host`, `original_fullpath`, `params`, `env` and `request_site` accessors; follow that pattern rather than
building a Rails request.

## Code Style

- RuboCop (`.rubocop.yml`): target Ruby 3.2.2, NewCops, rubocop-rake and rubocop-rspec; AbcSize 26,
  MethodLength 15, BlockLength 66, ModuleLength 150; `Lint/ConstantDefinitionInBlock` and `Lint/Void`
  are off for `lib/bp3/**/railtie.rb`, where classes are reopened inside a block
- Every file starts with `# frozen_string_literal: true`
- American English; no trailing whitespace on any added or modified line

## Release

Bump `lib/bp3/action_dispatch/version.rb` and add a `CHANGELOG.md` entry. `rake release` tags, pushes and
publishes to rubygems.org; leave releasing and committing to the user.
