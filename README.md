# Interactive graph editor
## Online version
- ### [Try here!](https://br4ch1st0chr0n3.github.io/elm-graph-editor/)

## Interface demo
<div style="margin-top: 10px;">
    <img src="./README/demo.png" width=400px height=auto;></img>
</div>


## Wanna learn about Elm?
- ### [Visit their site](https://elm-lang.org/)

## Hosting Elm project on Github

1. Copy `.github` folder into your (at least locally correctly working) project. 
1. Make sure your main `.elm` file is at `src/Main.elm`. This is needed for the command `elm make src/Main.elm --output src/Main.js` in `.github/workflows/main.yml` to work.
1. Push changes to your remote repository on GitHub (**GH repo**).
1. Create a new workflow, following [the instructions](https://docs.github.com/en/actions/quickstart).
1. Next, push some commit to your GH repo. This will automatically create a new branch `gh-pages`.
1. Go to **Actions** -> **All workflows** -> Check if workflow was run successfully.
1. Go to **Settings** -> **Pages** -> **Source** -> **Branch**: `gh-pages` -> Click **Save**.
1. Now, if you see *Your site is published at* **link**, click this link.
1. Enjoy!