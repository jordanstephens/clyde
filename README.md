# Clyde

<img src="doc-assets/clyde.png" alt="Clyde" align="right" />

Clyde is a command line tool built on [Capybara](http://jnicklas.github.io/capybara) and [PhantomJS](http://phantomjs.org) which aims to automate testing for visual regressions between two hosts (for example, staging and production). Clyde compares screenshots of pages at each host and identifies pages which render differently between the two hosts.

Clyde is a system with intentions which differ from a typical test with binary *passing* and *failure* states. Clyde reports *changes*, and aims to notify users of changes which have occured unexpectedly. In the event that changes are expected, Clyde can help verify that the scope of the changes matches the scope that was expected.

## Installation

Add Clyde to your application's Gemfile:

    gem "clyde"

And install it with bundler:

    $ bundle

## Usage

Clyde is run from the command line and uses a special `Clydefile` to define its inputs.

To get started, generate a `Clydefile`:

    $ bundle exec clyde --init

After customizing your `Clydefile` (see the **[Clydefile](#clydefile)** section for details), run Clyde with:

    $ bundle exec clyde

## Clydefile

The `Clydefile` uses a special DSL for defining Clyde inputs. The file's contents are evaluated as ruby, so you can write regular ruby code in your `Clydefile`.

**An example Clydefile looks like this:**

    hosts "example.com", "staging.example.com"

    paths %w(
      /about
      /contact
    )

    # use the following block to run code before taking screenshots
    # on each page
    # before :each do |page, opts|
    # end

    # use the following block to run code before taking screenshots
    # on pages with urls that match the given pattern
    # before /\d+/ do |page, opts|
    # end

### Clydefile DSL

The `Clydefile` is used to define three types of inputs to Clyde: hosts, paths, and before hooks.

#### Hosts

Use `hosts` to define the two hosts to use for screenshot comparisons:

    hosts "example.com", "staging.example.com"

#### Paths

Use `paths` to define a list of paths to visit, screenshot, and compare between the two pre-defined hosts.

    paths %w(
      /about
      /contact
    )

#### Before Hooks

Use `before` to run code after a page has loaded, but before the screenshot is taken. Hooks can be defined to run on each page or only on pages which have url pathss that match a pattern.

##### Hook Resources

Hook blocks have two resources available to them: `page` and `opts`:

* `page` is the [`Capybara::Session`](http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Session). It is the interface with which you can interact with the current page.
* `opts` is a `Hash` of *screenshot options* that is passed to phantomjs to capture the screenshot. Default is `{ full: true }` which will capture the whole page, but you can alternatively define a selector to capture by using `{ selector: "#id" }`.

##### Hook Examples

To define a hook for **each** page:

    before :each do |page, opts|
      # custom code...
    end

To define a hook for **matched** pages (in this case, this code will only run on pages with numeric paths):

    before /\d+/ do |page, opts|
      # custom code...
    end
    
## Running Tests

Run Clyde tests locally with:

    $ bundle exec rspec spec

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

