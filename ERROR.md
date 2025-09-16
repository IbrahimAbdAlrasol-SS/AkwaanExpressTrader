estarted application in 4,371ms.
I/flutter ( 5708): [🌎 Easy Localization] [DEBUG] Localization initialized
I/flutter ( 5708): [🌎 Easy Localization] [DEBUG] Start
I/flutter ( 5708): [🌎 Easy Localization] [DEBUG] Init state
I/flutter ( 5708): [🌎 Easy Localization] [INFO] Start locale loaded ar
I/flutter ( 5708): [🌎 Easy Localization] [DEBUG] Build
I/flutter ( 5708): [🌎 Easy Localization] [DEBUG] Init Localization Delegate
I/flutter ( 5708): [🌎 Easy Localization] [DEBUG] Init provider
I/flutter ( 5708): [🌎 Easy Localization] [DEBUG] Load Localization Delegate
I/flutter ( 5708): [🌎 Easy Localization] [DEBUG] Load asset from assets/lang
I/.example.Tosell( 5708): AssetManager2(0x7048bbb2fa18) locale list changing from [] to [en-US]
W/WindowOnBackDispatcher( 5708): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher( 5708): Set 'android:enableOnBackInvokedCallback="true"' in the application manifest.

════════ Exception caught by rendering library ═════════════════════════════════
The following assertion was thrown during layout:
A RenderFlex overflowed by 11 pixels on the bottom.

The relevant error-causing widget was:
    Column Column:file:///C:/Users/Zeus/Desktop/final_tosll/Omar_Toselli/lib/features/auth/login/presentation/widgets/sheet_content.dart:37:12

: To inspect this widget in Flutter DevTools, visit: http://127.0.0.1:9102/#/inspector?uri=http%3A%2F%2F127.0.0.1%3A28482%2F8wtNG0eqfkQ%3D%2F&inspectorRef=inspector-0

The overflowing RenderFlex has an orientation of Axis.vertical.
The edge of the RenderFlex that is overflowing has been marked in the rendering with a yellow and black striped pattern. This is usually caused by the contents being too big for the RenderFlex.
Consider applying a flex factor (e.g. using an Expanded widget) to force the children of the RenderFlex to fit within the available space instead of being sized to their natural size.
This is considered an error condition because it indicates that there is content that cannot be seen. If the content is legitimately bigger than the available space, consider clipping it with a ClipRect widget before putting it in the flex, or using a scrollable container rather than a Flex, like a ListView.
The specific RenderFlex in question is: RenderFlex#5d08c OVERFLOWING
    needs compositing
    parentData: offset=Offset(20.0, 0.0) (can use size)
    constraints: BoxConstraints(w=371.4, h=588.3)
    size: Size(371.4, 588.3)
    direction: vertical
    mainAxisAlignment: start
    mainAxisSize: max
    crossAxisAlignment: start
    textDirection: rtl
    verticalDirection: down
    spacing: 0.0
    child 1: RenderGap#2108c relayoutBoundary=up1
        parentData: offset=Offset(371.4, 0.0); flex=null; fit=null (can use size)
        constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
        size: Size(0.0, 16.0)
        mainAxisExtent: 16.0
        crossAxisExtent: 0.0
        color: null
        fallbackDirection: null
    child 2: RenderPositionedBox#147fd relayoutBoundary=up1
        parentData: offset=Offset(0.0, 16.0); flex=null; fit=null (can use size)
        constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
        size: Size(371.4, 270.6)
        alignment: Alignment.center
        textDirection: rtl
        widthFactor: expand
        heightFactor: expand
        child: RenderSemanticsAnnotations#3c83f relayoutBoundary=up2
            parentData: offset=Offset(0.0, 0.0) (can use size)
            constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
            size: Size(371.4, 270.6)
            child: RenderImage#4773e relayoutBoundary=up3
                parentData: <none> (can use size)
                constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
                size: Size(371.4, 270.6)
                image: [1592×1160]
                alignment: Alignment.center
                invertColors: false
                filterQuality: medium
    child 3: RenderFlex#20464 relayoutBoundary=up1
        needs compositing
        parentData: offset=Offset(0.0, 286.6); flex=null; fit=null (can use size)
        constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
        size: Size(371.4, 192.0)
        direction: vertical
        mainAxisAlignment: start
        mainAxisSize: max
        crossAxisAlignment: center
        verticalDirection: down
        spacing: 0.0
        child 1: RenderFlex#cbb43 relayoutBoundary=up2
            needs compositing
            parentData: offset=Offset(0.0, 0.0); flex=null; fit=null (can use size)
            constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
            size: Size(371.4, 88.0)
            direction: vertical
            mainAxisAlignment: start
            mainAxisSize: max
            crossAxisAlignment: start
            textDirection: rtl
            verticalDirection: down
            spacing: 0.0
            child 1: RenderParagraph#4a142 relayoutBoundary=up3
                parentData: offset=Offset(295.0, 0.0); flex=null; fit=null (can use size)
                constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
                size: Size(76.5, 24.0)
                textAlign: start
                textDirection: rtl
                softWrap: wrapping at box width
                overflow: clip
                locale: ar
                maxLines: unlimited
                text: TextSpan
                    debugLabel: ((tall bodyLarge 2021).merge(((whiteMountainView bodyLarge).apply).apply)).copyWith
                    inherit: false
                    color: Color(alpha: 1.0000, red: 0.8863, green: 0.9098, blue: 0.9412, colorSpace: ColorSpace.sRGB)
                    family: Tajawal
                    size: 16.0
                    weight: 400
                    letterSpacing: 0.5
                    baseline: alphabetic
                    height: 1.5x
                    leadingDistribution: even
                    decoration: Color(alpha: 1.0000, red: 0.8863, green: 0.9098, blue: 0.9412, colorSpace: ColorSpace.sRGB) TextDecoration.none
                    "رقم الهاتف"
            child 2: RenderGap#5a26d relayoutBoundary=up3
                parentData: offset=Offset(371.4, 24.0); flex=null; fit=null (can use size)
                constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
                size: Size(0.0, 8.0)
                mainAxisExtent: 8.0
                crossAxisExtent: 0.0
                color: null
                fallbackDirection: null
            child 3: RenderFlex#6897c relayoutBoundary=up3
                needs compositing
                parentData: offset=Offset(0.0, 32.0); flex=null; fit=null (can use size)
                constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
                size: Size(371.4, 56.0)
                direction: horizontal
                mainAxisAlignment: start
                mainAxisSize: max
                crossAxisAlignment: center
                textDirection: rtl
                verticalDirection: down
                spacing: 0.0
                child 1: RenderSemanticsAnnotations#659f0 relayoutBoundary=up4
                    needs compositing
                    parentData: offset=Offset(0.0, 0.0); flex=1; fit=FlexFit.tight (can use size)
                    constraints: BoxConstraints(w=371.4, 0.0<=h<=Infinity)
                    size: Size(371.4, 56.0)
        child 2: RenderGap#01f0b relayoutBoundary=up2
            parentData: offset=Offset(185.7, 88.0); flex=null; fit=null (can use size)
            constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
            size: Size(0.0, 16.0)
            mainAxisExtent: 16.0
            crossAxisExtent: 0.0
            color: null
            fallbackDirection: null
        child 3: RenderFlex#021c4 relayoutBoundary=up2
            needs compositing
            parentData: offset=Offset(0.0, 104.0); flex=null; fit=null (can use size)
            constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
            size: Size(371.4, 88.0)
            direction: vertical
            mainAxisAlignment: start
            mainAxisSize: max
            crossAxisAlignment: start
            textDirection: rtl
            verticalDirection: down
            spacing: 0.0
            child 1: RenderParagraph#9080d relayoutBoundary=up3
                parentData: offset=Offset(292.2, 0.0); flex=null; fit=null (can use size)
                constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
                size: Size(79.3, 24.0)
                textAlign: start
                textDirection: rtl
                softWrap: wrapping at box width
                overflow: clip
                locale: ar
                maxLines: unlimited
                text: TextSpan
                    debugLabel: ((tall bodyLarge 2021).merge(((whiteMountainView bodyLarge).apply).apply)).copyWith
                    inherit: false
                    color: Color(alpha: 1.0000, red: 0.8863, green: 0.9098, blue: 0.9412, colorSpace: ColorSpace.sRGB)
                    family: Tajawal
                    size: 16.0
                    weight: 400
                    letterSpacing: 0.5
                    baseline: alphabetic
                    height: 1.5x
                    leadingDistribution: even
                    decoration: Color(alpha: 1.0000, red: 0.8863, green: 0.9098, blue: 0.9412, colorSpace: ColorSpace.sRGB) TextDecoration.none
                    "كلمة المرور"
            child 2: RenderGap#d6c96 relayoutBoundary=up3
                parentData: offset=Offset(371.4, 24.0); flex=null; fit=null (can use size)
                constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
                size: Size(0.0, 8.0)
                mainAxisExtent: 8.0
                crossAxisExtent: 0.0
                color: null
                fallbackDirection: null
            child 3: RenderFlex#d4935 relayoutBoundary=up3
                needs compositing
                parentData: offset=Offset(0.0, 32.0); flex=null; fit=null (can use size)
                constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
                size: Size(371.4, 56.0)
                direction: horizontal
                mainAxisAlignment: start
                mainAxisSize: max
                crossAxisAlignment: center
                textDirection: rtl
                verticalDirection: down
                spacing: 0.0
                child 1: RenderSemanticsAnnotations#5ac8c relayoutBoundary=up4
                    needs compositing
                    parentData: offset=Offset(0.0, 0.0); flex=1; fit=FlexFit.tight (can use size)
                    constraints: BoxConstraints(w=371.4, 0.0<=h<=Infinity)
                    size: Size(371.4, 56.0)
    child 4: RenderGap#b061c relayoutBoundary=up1
        parentData: offset=Offset(371.4, 478.6); flex=null; fit=null (can use size)
        constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
        size: Size(0.0, 16.0)
        mainAxisExtent: 16.0
        crossAxisExtent: 0.0
        color: null
        fallbackDirection: null
    child 5: RenderFlex#41989 relayoutBoundary=up1
        parentData: offset=Offset(0.0, 494.6); flex=null; fit=null (can use size)
        constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
        size: Size(371.4, 20.0)
        direction: horizontal
        mainAxisAlignment: start
        mainAxisSize: max
        crossAxisAlignment: center
        textDirection: rtl
        verticalDirection: down
        spacing: 0.0
        child 1: RenderParagraph#1ef57 relayoutBoundary=up2
            parentData: offset=Offset(260.3, 0.0); flex=null; fit=null (can use size)
            constraints: BoxConstraints(unconstrained)
            size: Size(111.1, 20.0)
            textAlign: start
            textDirection: rtl
            softWrap: wrapping at box width
            overflow: clip
            locale: ar
            maxLines: unlimited
            text: TextSpan
                debugLabel: ((tall bodyMedium 2021).merge(((whiteMountainView bodyMedium).apply).apply)).merge(unknown)
                inherit: false
                color: Color(alpha: 1.0000, red: 0.6118, green: 0.6392, blue: 0.6863, colorSpace: ColorSpace.sRGB)
                family: Tajawal
                size: 14.0
                weight: 400
                letterSpacing: 0.3
                baseline: alphabetic
                height: 1.4x
                leadingDistribution: even
                decoration: Color(alpha: 1.0000, red: 0.8863, green: 0.9098, blue: 0.9412, colorSpace: ColorSpace.sRGB) TextDecoration.none
                "ليس لديك حساب؟"
        child 2: RenderGap#21d5d relayoutBoundary=up2
            parentData: offset=Offset(256.3, 10.0); flex=null; fit=null (can use size)
            constraints: BoxConstraints(unconstrained)
            size: Size(4.0, 0.0)
            mainAxisExtent: 4.0
            crossAxisExtent: 0.0
            color: null
            fallbackDirection: null
        child 3: RenderSemanticsGestureHandler#d1ece relayoutBoundary=up2
            parentData: offset=Offset(172.8, 0.0); flex=null; fit=null (can use size)
            constraints: BoxConstraints(unconstrained)
            size: Size(83.5, 20.0)
            behavior: deferToChild
            gestures: tap
            child: RenderPointerListener#d720c relayoutBoundary=up3
                parentData: <none> (can use size)
                constraints: BoxConstraints(unconstrained)
                size: Size(83.5, 20.0)
                behavior: deferToChild
                listeners: down, panZoomStart
                child: RenderParagraph#4f425 relayoutBoundary=up4
                    parentData: <none> (can use size)
                    constraints: BoxConstraints(unconstrained)
                    size: Size(83.5, 20.0)
                    textAlign: start
                    textDirection: rtl
                    softWrap: wrapping at box width
                    overflow: clip
                    locale: ar
                    maxLines: unlimited
    child 6: RenderGap#b276a relayoutBoundary=up1
        parentData: offset=Offset(371.4, 514.6); flex=null; fit=null (can use size)
        constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
        size: Size(0.0, 24.0)
        mainAxisExtent: 24.0
        crossAxisExtent: 0.0
        color: null
        fallbackDirection: null
    child 7: RenderConstrainedBox#fb8f7 relayoutBoundary=up1
        parentData: offset=Offset(0.0, 538.6); flex=null; fit=null (can use size)
        constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
        size: Size(371.4, 45.0)
        additionalConstraints: BoxConstraints(0.0<=w<=Infinity, h=45.0)
        child: RenderSemanticsAnnotations#7062d relayoutBoundary=up2
            parentData: <none> (can use size)
            constraints: BoxConstraints(0.0<=w<=371.4, h=45.0)
            semantic boundary
            size: Size(371.4, 45.0)
            child: _RenderInputPadding#575b3 relayoutBoundary=up3
                parentData: <none> (can use size)
                constraints: BoxConstraints(0.0<=w<=371.4, h=45.0)
                size: Size(371.4, 45.0)
                child: RenderConstrainedBox#94ec2 relayoutBoundary=up4
                    parentData: offset=Offset(0.0, 0.0) (can use size)
                    constraints: BoxConstraints(0.0<=w<=371.4, h=45.0)
                    size: Size(371.4, 45.0)
                    additionalConstraints: BoxConstraints(64.0<=w<=Infinity, 40.0<=h<=Infinity)
    child 8: RenderGap#28f7c relayoutBoundary=up1
        parentData: offset=Offset(371.4, 583.6); flex=null; fit=null (can use size)
        constraints: BoxConstraints(0.0<=w<=371.4, 0.0<=h<=Infinity)
        size: Size(0.0, 16.0)
        mainAxisExtent: 16.0
        crossAxisExtent: 0.0
        color: null
        fallbackDirection: null