# Contributing to `homebrew-formal`

Thank you for your interest in contributing to this tap!
At the moment we are mainly interested in bug reports, fixes to existing formulae,
and creation of new formulae.

Note: as part of the larger Homebrew community, we expect all contributors to
adhere to the [Homebrew Code of Conduct](https://github.com/Homebrew/.github/blob/HEAD/CODE_OF_CONDUCT.md#code-of-conduct).

## Reporting bugs

Open a [GitHub issue](https://github.com/lou1306/homebrew-formal/issues/new).
Make sure that:

* You have followed [the Homebrew Troubleshooting Checklist](https://docs.brew.sh/Troubleshooting) and the issue still persists.
* The issue title clearly contains the name of the formula.
* You attach the output of `brew doctor` to the issue.

## Adding/updating a formula

1. Fork this repository
2. Create a feature branch on your fork
3. Add/update *a single formula*
4. Make sure that `brew audit` returns no warnings/errors for that formula
5. Push the branch on GitHub
6. Open a pull request

## Bottling

Once a formula is ready, *and* if the tool's license allows redistribution,
one of the maintainers may attempt to bottle it.
[Bottles](https://docs.brew.sh/Bottles) are binary packages that Homebrew 
may automatically retrieve and install rather than building the tool from
scratch.

## Adding/updating a Cask

If the tool is closed-source but has a license that allow redistribution,
we can accept a Cask instead. Casks are stored in the `Casks` directory
and are a more compact recipe for downloading and installing binaries.

If a tool *is* open-source but has a rather convoluted build process,
we can accept a Cask as a temporary measure to make the tool available until
a proper formula is developed. (Let us be pragmatic). In such cases the
cask should be kept until said formula has been tested and bottled for both
x86_64 and arm64 architectures.

## Basic guidelines

1. Whenever possible, attach license information to new formula. We will
   not accept Cas without any such information. Similarly, we will not
   bottle a formula lacking a license that allows redistribution.
2. We would *prefer* to maintain retro-compatibility with upstream
   (`mht208/homebrew-formal`). When PRing a formula that also appears there,
   consider having separate commits for a) the new formula, *without*
   any `bottle` stanzas, and b) (optional) bottle information. This way,
   we can branch out the bottle-less formula and submit it upstream.
3. We will not accept new formulae that are clearly research prototypes.
   Lines here are blurry, and we should not be *too* strict, but attaching
   information about usage in the PR would help us judge the maturity
   of a proposed new tool.
4. Perhaps needless to say, but we won't accept tools that are already in
   `homebrew-core` or `homebrew-cask`. Examples include `cbmc`,
   `cryptominisat`, and `z3`.

## ToDos

Stuff that may be automated (help welcome!)

* `brew audit` checks on new PRs
* Bottling new formulae (if they satisfy the requirements) for all
  architectures

  (I did try to use homebrew's default actions based on `brew test-bot`
but they do not seem to jive well with the structure of this tap.)

## Additional caveats

Please refer to the (Homebrew prose style guidelines)[https://docs.brew.sh/Prose-Style-Guidelines]
for style advice regarding prose documentation (e.g., formula descriptions).

For all other contribution ideas, please just open a new issue.

