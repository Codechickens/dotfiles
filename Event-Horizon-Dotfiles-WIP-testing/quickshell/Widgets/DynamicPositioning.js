// DynamicPositioning.js - Core positioning logic for popups
// This handles all position calculations dynamically based on bar position, screen size, and widget triggers

/**
 * Screen metrics and scaling utilities
 */
const ScreenUtils = {
    /**
     * Get comprehensive screen information
     */
    getMetrics: function(screen) {
        if (!screen) {
            console.warn("[DynamicPositioning] No screen provided, using defaults")
            return {
                x: 0,
                y: 0,
                width: 1920,
                height: 1080,
                scale: 1.0,
                isValid: false
            }
        }
        
        return {
            x: screen.x || 0,
            y: screen.y || 0,
            width: screen.width || 1920,
            height: screen.height || 1080,
            scale: screen.devicePixelRatio || 1.0,
            isValid: true
        }
    },
    
    /**
     * Calculate adaptive scale factor for UI elements
     * Scales UP for larger screens, 1440p and smaller stay at 1.0
     * Formula: scale = max(1.0, screenWidth / 2560)
     */
    getAdaptiveScale: function(screenWidth, screenHeight, baseScale = 1.0) {
        // Reference: 2560x1440 = 1.0 scale
        // Larger screens scale up, smaller screens stay at 1.0
        const scale = Math.max(1.0, screenWidth / 2560)
        
        // Apply base scale from settings
        return scale * baseScale
    },
    
    /**
     * Get safe margins to keep popups on screen
     */
    getSafeMargins: function(screenMetrics) {
        const baseMargin = 8
        const scaledMargin = baseMargin * screenMetrics.scale
        
        return {
            top: scaledMargin,
            bottom: scaledMargin,
            left: scaledMargin,
            right: scaledMargin
        }
    }
}

/**
 * Bar configuration and measurements
 */
const BarUtils = {
    /**
     * Get effective bar dimensions including spacing and gaps
     */
    getBarDimensions: function(barPosition, barThickness, barSpacing, bottomGap, screenMetrics) {
        const scaledThickness = barThickness * screenMetrics.scale
        const scaledSpacing = barSpacing * screenMetrics.scale
        const scaledBottomGap = bottomGap * screenMetrics.scale
        
        // Calculate total bar size including spacing
        let totalSize = scaledThickness + scaledSpacing
        
        // Add bottom gap for bottom-positioned bars
        if (barPosition === "bottom") {
            totalSize += scaledBottomGap
        }
        
        return {
            thickness: scaledThickness,
            spacing: scaledSpacing,
            bottomGap: scaledBottomGap,
            totalSize: totalSize
        }
    },
    
    /**
     * Get the bar bounds on screen
     */
    getBarBounds: function(barPosition, barDimensions, screenMetrics) {
        let bounds = {
            x: 0,
            y: 0,
            width: 0,
            height: 0
        }
        
        switch (barPosition) {
            case "top":
                bounds.x = screenMetrics.x
                bounds.y = screenMetrics.y
                bounds.width = screenMetrics.width
                bounds.height = barDimensions.totalSize
                break
                
            case "bottom":
                bounds.x = screenMetrics.x
                bounds.y = screenMetrics.y + screenMetrics.height - barDimensions.totalSize
                bounds.width = screenMetrics.width
                bounds.height = barDimensions.totalSize
                break
                
            case "left":
                bounds.x = screenMetrics.x
                bounds.y = screenMetrics.y
                bounds.width = barDimensions.totalSize
                bounds.height = screenMetrics.height
                break
                
            case "right":
                bounds.x = screenMetrics.x + screenMetrics.width - barDimensions.totalSize
                bounds.y = screenMetrics.y
                bounds.width = barDimensions.totalSize
                bounds.height = screenMetrics.height
                break
        }
        
        return bounds
    }
}

/**
 * Widget and trigger calculations
 */
const TriggerUtils = {
    /**
     * Get widget center point in screen coordinates
     */
    getWidgetCenter: function(triggerX, triggerY, triggerWidth, triggerHeight) {
        return {
            x: triggerX + (triggerWidth / 2),
            y: triggerY + (triggerHeight / 2)
        }
    },
    
    /**
     * Determine which side of the bar the widget is on
     * Returns: "left", "center", "right" for horizontal bars
     *          "top", "middle", "bottom" for vertical bars
     */
    getWidgetSection: function(triggerX, triggerY, triggerWidth, screenMetrics, barPosition) {
        // Convert triggerX to screen-relative
        const screenX = screenMetrics.x || 0
        const screenRelX = triggerX - screenX
        const center = TriggerUtils.getWidgetCenter(screenRelX, triggerY, triggerWidth, 0)
        
        if (barPosition === "left" || barPosition === "right") {
            // Vertical bar - check Y position
            const thirdHeight = screenMetrics.height / 3
            const screenTop = screenMetrics.y
            
            if (center.y < screenTop + thirdHeight) {
                return "top"
            } else if (center.y < screenTop + thirdHeight * 2) {
                return "middle"
            } else {
                return "bottom"
            }
        } else {
            // Horizontal bar - check X position
            const thirdWidth = screenMetrics.width / 3
            const screenLeft = 0  // Already converted to screen-relative
            
            if (center.x < screenLeft + thirdWidth) {
                return "left"
            } else if (center.x < screenLeft + thirdWidth * 2) {
                return "center"
            } else {
                return "right"
            }
        }
    }
}

/**
 * Main positioning calculator
 */
const PositionCalculator = {
    /**
     * Calculate popup position for a horizontal bar (top or bottom)
     */
    calculateHorizontalPosition: function(config) {
        const {
            barPosition,
            barBounds,
            triggerX,
            triggerY,
            triggerWidth,
            popupWidth,
            popupHeight,
            popupGap,
            screenMetrics,
            safeMargins,
            widgetSection
        } = config
        
        let x, y
        
        // Convert triggerX to screen-relative coordinates
        const screenX = screenMetrics.x || 0
        const screenRelX = triggerX - screenX
        
        // X Position: Center on widget, but keep on screen
        const widgetCenterX = screenRelX + (triggerWidth / 2)
        x = widgetCenterX - (popupWidth / 2)
        
        // Clamp X to screen bounds with margins
        const minX = screenMetrics.x + safeMargins.left
        const maxX = screenMetrics.x + screenMetrics.width - popupWidth - safeMargins.right
        x = Math.max(minX, Math.min(maxX, x))
        
        // Y Position: Above or below the bar based on bar position
        if (barPosition === "top") {
            // Bar at top: popup goes below
            y = barBounds.y + barBounds.height + popupGap
            
            // Make sure it fits on screen
            const maxY = screenMetrics.y + screenMetrics.height - popupHeight - safeMargins.bottom
            y = Math.min(y, maxY)
            
        } else { // bottom
            // Bar at bottom: popup goes above
            y = barBounds.y - popupHeight - popupGap
            
            // Make sure it fits on screen
            const minY = screenMetrics.y + safeMargins.top
            y = Math.max(y, minY)
        }
        
        return { x, y }
    },
    
    /**
     * Calculate popup position for a vertical bar (left or right)
     */
    calculateVerticalPosition: function(config) {
        const {
            barPosition,
            barBounds,
            triggerX,
            triggerY,
            triggerWidth,
            triggerHeight,
            popupWidth,
            popupHeight,
            popupGap,
            screenMetrics,
            safeMargins,
            widgetSection
        } = config
        
        let x, y
        
        // Convert trigger coordinates to screen-relative
        const screenY = screenMetrics.y || 0
        const screenRelY = triggerY - screenY
        
        // Y Position: Center on widget, but keep on screen
        const widgetCenterY = screenRelY + (triggerHeight / 2)
        y = widgetCenterY - (popupHeight / 2)
        
        // Clamp Y to screen bounds with margins
        const minY = screenMetrics.y + safeMargins.top
        const maxY = screenMetrics.y + screenMetrics.height - popupHeight - safeMargins.bottom
        y = Math.max(minY, Math.min(maxY, y))
        
        // X Position: Left or right of the bar based on bar position
        if (barPosition === "left") {
            // Bar at left: popup goes to the right
            x = barBounds.x + barBounds.width + popupGap
            
            // Make sure it fits on screen
            const maxX = screenMetrics.x + screenMetrics.width - popupWidth - safeMargins.right
            x = Math.min(x, maxX)
            
        } else { // right
            // Bar at right: popup goes to the left
            x = barBounds.x - popupWidth - popupGap
            
            // Make sure it fits on screen
            const minX = screenMetrics.x + safeMargins.left
            x = Math.max(x, minX)
        }
        
        return { x, y }
    },
    
    /**
     * Main entry point: Calculate popup position
     */
    calculate: function(params) {
        // Extract and validate parameters
        const {
            // Screen and bar info
            screen,
            barPosition = "bottom",
            barThickness = 48,
            barSpacing = 4,
            bottomGap = 0,
            
            // Trigger/widget info
            triggerX = 0,
            triggerY = 0,
            triggerWidth = 80,
            triggerHeight = 48,
            
            // Popup dimensions
            popupWidth = 470,
            popupHeight = 600,
            
            // Spacing
            popupGap = 8,
            
            // Scaling
            userScale = 1.0
        } = params
        
        // Get screen metrics
        const screenMetrics = ScreenUtils.getMetrics(screen)
        
        // Calculate adaptive scale
        const adaptiveScale = ScreenUtils.getAdaptiveScale(
            screenMetrics.width,
            screenMetrics.height,
            userScale
        )
        
        // Apply scale to popup dimensions
        const scaledPopupWidth = popupWidth * adaptiveScale
        const scaledPopupHeight = popupHeight * adaptiveScale
        const scaledPopupGap = popupGap * screenMetrics.scale
        
        // Get bar dimensions
        const barDimensions = BarUtils.getBarDimensions(
            barPosition,
            barThickness,
            barSpacing,
            bottomGap,
            screenMetrics
        )
        
        // Get bar bounds
        const barBounds = BarUtils.getBarBounds(
            barPosition,
            barDimensions,
            screenMetrics
        )
        
        // Get safe margins
        const safeMargins = ScreenUtils.getSafeMargins(screenMetrics)
        
        // Determine widget section
        const widgetSection = TriggerUtils.getWidgetSection(
            triggerX,
            triggerY,
            triggerWidth,
            screenMetrics,
            barPosition
        )
        
        // Build config for position calculation
        const config = {
            barPosition,
            barBounds,
            triggerX,
            triggerY,
            triggerWidth,
            triggerHeight: triggerHeight || barThickness,
            popupWidth: scaledPopupWidth,
            popupHeight: scaledPopupHeight,
            popupGap: scaledPopupGap,
            screenMetrics,
            safeMargins,
            widgetSection
        }
        
        // Calculate position based on bar orientation
        let position
        if (barPosition === "top" || barPosition === "bottom") {
            position = PositionCalculator.calculateHorizontalPosition(config)
        } else {
            position = PositionCalculator.calculateVerticalPosition(config)
        }
        
        // Log debug info
        console.log("[DynamicPositioning] Calculated position:")
        console.log(`  Screen: ${screenMetrics.width}x${screenMetrics.height} @ (${screenMetrics.x}, ${screenMetrics.y})`)
        console.log(`  Bar: ${barPosition}, thickness: ${barThickness}, total size: ${barDimensions.totalSize}`)
        console.log(`  Bar bounds: (${barBounds.x}, ${barBounds.y}) ${barBounds.width}x${barBounds.height}`)
        console.log(`  Trigger: (${triggerX}, ${triggerY}) ${triggerWidth}x${triggerHeight}, section: ${widgetSection}`)
        console.log(`  Popup: ${scaledPopupWidth}x${scaledPopupHeight} (scale: ${adaptiveScale.toFixed(2)})`)
        console.log(`  Final position: (${position.x.toFixed(1)}, ${position.y.toFixed(1)})`)
        
        return {
            x: position.x,
            y: position.y,
            width: scaledPopupWidth,
            height: scaledPopupHeight,
            scale: adaptiveScale,
            widgetSection: widgetSection,
            barBounds: barBounds,
            screenMetrics: screenMetrics
        }
    }
}

// Export the main function
function calculatePopupPosition(params) {
    return PositionCalculator.calculate(params)
}
