# Icon Creation Guide

## Icon Concept: Pocket + Paw

A premium minimalist app icon combining a simple pocket outline with a small paw symbol using negative space.

## Visual Requirements

### Style
- Flat vector design
- Geometric, clean lines
- No gradients
- No shadows
- No 3D effects
- No cartoon style
- Strong negative space
- Modern, calm, professional aesthetic

### Color Scheme
- Primary: Black (#000000) and White (#FFFFFF)
- Optional accent: Emerald (#0F766E) - very subtle if used

## Android Icon Assets

### Required Files

1. **ic_launcher_foreground.png**
   - Size: 432x432 pixels
   - Format: PNG with transparent background
   - Icon centered in safe zone (288x288)
   - Location: `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` (references this)

2. **ic_launcher_background.png**
   - Size: 432x432 pixels
   - Format: PNG
   - Solid color background (black or white recommended)
   - Location: `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` (references this)

3. **ic_launcher_monochrome.png**
   - Size: 432x432 pixels
   - Format: PNG with transparent background
   - Black/white only
   - Same safe zone as foreground (288x288)
   - Location: `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` (references this)

### Directory Structure
```
android/app/src/main/res/
  mipmap-anydpi-v26/
    ic_launcher.xml
    ic_launcher_round.xml
  mipmap-mdpi/
    ic_launcher.png (48x48)
    ic_launcher_foreground.png (108x108)
    ic_launcher_background.png (108x108)
    ic_launcher_monochrome.png (108x108)
  mipmap-hdpi/
    ic_launcher.png (72x72)
    ic_launcher_foreground.png (162x162)
    ic_launcher_background.png (162x162)
    ic_launcher_monochrome.png (162x162)
  mipmap-xhdpi/
    ic_launcher.png (96x96)
    ic_launcher_foreground.png (216x216)
    ic_launcher_background.png (216x216)
    ic_launcher_monochrome.png (216x216)
  mipmap-xxhdpi/
    ic_launcher.png (144x144)
    ic_launcher_foreground.png (324x324)
    ic_launcher_background.png (324x324)
    ic_launcher_monochrome.png (324x324)
  mipmap-xxxhdpi/
    ic_launcher.png (192x192)
    ic_launcher_foreground.png (432x432)
    ic_launcher_background.png (432x432)
    ic_launcher_monochrome.png (432x432)
```

## iOS Icon Asset

### Required File

**app_icon_1024.png**
- Size: 1024x1024 pixels
- Format: PNG
- No transparency
- Centered, balanced composition
- Location: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

## Image Generation Prompt

Use this prompt in your image generation tool (DALL-E, Midjourney, Stable Diffusion, etc.):

```
A premium minimalist app icon for a virtual pet app called Pet Pocket. 
A simple pocket outline combined with a small paw symbol, using negative space. 
Flat vector design, geometric, clean lines, no gradients, no text, no cartoon style.
Modern, calm, and professional aesthetic suitable for a mobile app.
Black and white color scheme, high contrast, centered composition.
```

## Alternative: Manual Creation

If creating manually:
1. Use vector graphics software (Illustrator, Figma, Inkscape)
2. Create a simple pocket shape (rounded rectangle with opening at top)
3. Add a small paw symbol inside or integrated using negative space
4. Export at required sizes
5. Ensure all icons maintain the same visual weight and balance

## Testing

After creating icons:
1. Build and install the app
2. Verify icon appears correctly in launcher
3. Check monochrome version for Android 13+ themed icons
4. Ensure icon is readable at small sizes
5. Test on different device backgrounds (light/dark)

