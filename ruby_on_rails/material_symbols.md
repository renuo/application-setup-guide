# Material Symbols

You can either include Material Symbols via the Google CDN, download the font, or download the SVGs separately.

## Installation

1. Insert the code from [fonts.googleapis.com](https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0) into your CSS file.
1. Download the WOFF2 file from the `src` URL and rename it, for example `material_symbols_outlined.woff2`.
1. Place the font file in the `app/assets/fonts/` directory.
1. Replace the URL to fonts.gstatic.com with the filename:

```css
@font-face {
  font-family: Material Symbols Outlined;
  src: url(material_symbols_outlined.woff2) format("woff2");
}
```

## Usage

1. Navigate to the [Material Symbols icon list](https://fonts.google.com/icons?icon.set=Material+Symbols)
1. Search for the icon that you want to include and copy paste it into the HTML. For example, the search icon uses this tag: `<span class="material-symbols-outlined">search</span>`.
1. You can also add a helper method if you want to use the icons with `icon(:search)`:

```rb
module ApplicationHelper
  def icon(name)
    tag.span(name, class: "material-symbols-outlined", "aria-hidden": true)
  end
end
```