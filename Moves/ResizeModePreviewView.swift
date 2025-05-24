import Cocoa

@IBDesignable
final class ResizeModePreviewView: NSView {
  @IBInspectable @objc dynamic var isClosestMode: Bool = false {
    didSet { mode = isClosestMode ? 1 : 0 }
  }

  private var mode: Int = 0 {
    didSet { needsDisplay = true }
  }

  private enum Style {
    static let outerInset: CGFloat = 6
    static let innerInset: CGFloat = 12
    static let cornerRadiusScale: CGFloat = 0.08
    static let borderWidth: CGFloat = 1.5
    static let arrowWidth: CGFloat = 1.5
    static let dashWidth: CGFloat = 1.0
    static let dashLength: CGFloat = 4.5
    static let arrowLengthMultiplier: CGFloat = 2.8
    static let arrowAngle: CGFloat = .pi / 6
  }

  override var intrinsicContentSize: NSSize {
    NSSize(width: 102, height: 57)
  }

  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    guard let context = NSGraphicsContext.current?.cgContext else { return }

    let strokeColor = NSColor.labelColor
    let secondaryColor = NSColor.secondaryLabelColor

    let outerRect = bounds.insetBy(dx: Style.outerInset, dy: Style.outerInset)
    let cornerRadius = min(outerRect.width, outerRect.height) * Style.cornerRadiusScale

    let borderPath = NSBezierPath(roundedRect: outerRect, xRadius: cornerRadius, yRadius: cornerRadius)
    borderPath.lineWidth = Style.borderWidth
    strokeColor.setStroke()
    borderPath.stroke()

    let insetRect = outerRect.insetBy(dx: Style.innerInset, dy: Style.innerInset)
    let center = CGPoint(x: outerRect.midX, y: outerRect.midY)

    if mode == 0 {
      drawArrow(
        from: center,
        to: CGPoint(x: insetRect.maxX, y: insetRect.minY),
        lineWidth: Style.arrowWidth,
        color: strokeColor,
        in: context
      )
      return
    }

    context.saveGState()
    context.setStrokeColor(secondaryColor.cgColor)
    context.setLineWidth(Style.dashWidth)
    context.setLineCap(.round)
    context.setLineDash(phase: 0, lengths: [Style.dashLength, Style.dashLength])
    context.move(to: CGPoint(x: outerRect.midX, y: outerRect.minY))
    context.addLine(to: CGPoint(x: outerRect.midX, y: outerRect.maxY))
    context.move(to: CGPoint(x: outerRect.minX, y: outerRect.midY))
    context.addLine(to: CGPoint(x: outerRect.maxX, y: outerRect.midY))
    context.strokePath()
    context.restoreGState()

    let targets = [
      CGPoint(x: insetRect.minX, y: insetRect.maxY),
      CGPoint(x: insetRect.maxX, y: insetRect.maxY),
      CGPoint(x: insetRect.minX, y: insetRect.minY),
      CGPoint(x: insetRect.maxX, y: insetRect.minY),
    ]

    targets.forEach { target in
      let vector = CGPoint(x: target.x - center.x, y: target.y - center.y)
      let start = CGPoint(x: center.x + vector.x * 0.35, y: center.y + vector.y * 0.35)
      let end = CGPoint(x: center.x + vector.x * 0.85, y: center.y + vector.y * 0.85)
      drawArrow(from: start, to: end, lineWidth: Style.arrowWidth, color: strokeColor, in: context)
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    mode = isClosestMode ? 1 : 0
  }

  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    mode = isClosestMode ? 1 : 0
  }

  private func drawArrow(
    from start: CGPoint,
    to end: CGPoint,
    lineWidth: CGFloat,
    color: NSColor,
    in context: CGContext
  ) {
    context.saveGState()
    context.setStrokeColor(color.cgColor)
    context.setLineWidth(lineWidth)
    context.setLineCap(.round)
    context.setLineJoin(.round)
    context.move(to: start)
    context.addLine(to: end)
    context.strokePath()

    let angle = atan2(end.y - start.y, end.x - start.x)
    let arrowLength = lineWidth * Style.arrowLengthMultiplier
    let arrowAngle = Style.arrowAngle

    let p1 = CGPoint(
      x: end.x - arrowLength * cos(angle - arrowAngle),
      y: end.y - arrowLength * sin(angle - arrowAngle)
    )
    let p2 = CGPoint(
      x: end.x - arrowLength * cos(angle + arrowAngle),
      y: end.y - arrowLength * sin(angle + arrowAngle)
    )

    context.move(to: end)
    context.addLine(to: p1)
    context.move(to: end)
    context.addLine(to: p2)
    context.strokePath()
    context.restoreGState()
  }
}
