<img src="https://s3.brnbw.com/AppIcon-512px-1f47lkdLKcbpBvUS5BPd44GqycBOYsuqi29ze15MtRqBukjm19pdECa2KYvz7PzKX8brpY5YhVnk962zoPi5CUygHEjR8WYqZLUX.png" width="256" height="256" alt="Moves.app" />

**Watch the introduction on YouTube:**

<div>
<a href="https://youtube.com/watch?v=YOzuhU9TEp8"><img src="https://img.youtube.com/vi/YOzuhU9TEp8/maxresdefault.jpg" width=480></a>
</div>

- ⚔️ Moves makes it easier than ever to position your windows _juuust_ right.
- ✨ Hold down your chosen modifier keys and move the mouse. No need to fiddle with 3px wide window edges or far away title bars.
- ⚡️ Moves lives in your menubar and is very light weight. The only thing it does, it does well.

## Release

```sh
cp .env.example .env
just distribute
```

Pass `VERSION=1.9.3` to force the next version. Otherwise `just distribute` bumps the patch version, increments the build number, builds + notarizes `Moves.app`, uploads `Moves.app.zip` to GitHub Releases, updates `CHANGELOG.md`, writes `Updates/appcast.xml`, and updates `../homebrew-tap/Casks/moves.rb`. GitHub Pages publishes that committed `Updates/appcast.xml` at the existing app URL.

## URL schemes

Moves supports the following URL schemes for window positioning:

### Template-based positioning

```
moves://template/{template-name}
```

Apply a predefined window template to the active window.

#### Available Templates

| Category | Templates |
|----------|-----------|
| **Full screen** | `toggle-fullscreen`, `maximize`, `maximize-height` (keeps x position), `maximize-width` (keeps y position) |
| **Half screen** | `left-half`, `right-half`, `top-half`, `bottom-half` |
| **Center & Movement** | `center`, `move-up`, `move-down`, `move-left`, `move-right`, `restore`, `reasonable-size` |
| **Display management** | `previous-display`, `next-display` |
| **Thirds** | `first-third`, `first-two-thirds`, `center-third`, `last-two-thirds`, `last-third` |
| **Fourths** | `first-fourth`, `second-fourth`, `third-fourth`, `last-fourth` |
| **Quarters (corners)** | `top-left-quarter`, `top-right-quarter`, `bottom-left-quarter`, `bottom-right-quarter` |
| **Sixths** | `top-left-sixth`, `top-center-sixth`, `top-right-sixth`, `bottom-left-sixth`, `bottom-center-sixth`, `bottom-right-sixth` |

Example:
```sh
open moves://template/left-half
```

### Custom positioning

```
moves://custom/{position}?parameters
```

Position the active window with custom settings.

#### Position Values

| Position | Description |
|----------|-------------|
| `center` | Center of screen |
| `centerRight` | Middle of right edge |
| `centerLeft` | Middle of left edge |
| `topRight` | Top right corner |
| `topLeft` | Top left corner |
| `bottomRight` | Bottom right corner |
| `bottomLeft` | Bottom left corner |

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `absoluteWidth` | Number | Window width in pixels |
| `absoluteHeight` | Number | Window height in pixels |
| `relativeWidth` | Float (0-1) | Window width as ratio of screen width |
| `relativeHeight` | Float (0-1) | Window height as ratio of screen height |
| `absoluteXOffset` | Number | X position offset in pixels |
| `absoluteYOffset` | Number | Y position offset in pixels |
| `relativeXOffset` | Float | X position offset as ratio of screen width |
| `relativeYOffset` | Float | Y position offset as ratio of screen height |

Example:
```sh
open "moves://custom/center?relativeWidth=0.75&relativeHeight=0.75"
```

## License

MIT
