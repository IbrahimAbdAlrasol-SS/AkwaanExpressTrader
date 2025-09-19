كتاب: الأداء والسلاسة في تطبيقات Flutter — الأسباب، التشخيص، والحلول العملية
المقدمة
هذا المرجع يجمع كل ما تحتاجه لفهم لماذا يتعرقل تطبيق فلاتر عند التشغيل أو عند التمرير أو عند التفاعل. يغطي المفاهيم من المستوى النظري إلى حلول عملية قابلة للتطبيق في مشروع حقيقي. الهدف أن تصبح قادرًا على: قياس المشكلة بدقة، تحديد السبب الجذري، تطبيق إصلاحات منخفضة المخاطر، وقياس التحسّن بعد التعديل.
فهرس المحتويات
مفاهيم أساسية


أنبوب الرسم في Flutter (rendering pipeline)


فئات الأسباب: شائعة ونادرة


قياس الأداء وتشخيص الجانك (jank)


سياسات برمجة وأفضل ممارسات مفصلة


صور ووسائط: أساليب فعّالة


القوائم الكبيرة والـ Lazy Loading


إدارة الحالة وتأثيرها على إعادة البناء


الرسوم المتحركة والفيزوالز: امثلتهما وخيارات أخفّ أداءً


العمليات الثقيلة وعزلها (Isolates, compute)


الذاكرة، الـ GC، وتسريبات الذاكرة


مشكلات GPU وTexture وPlatform Views


حالات دراسية واقعية وحلولها


قائمة فحص عملية قبل الإصدار


أدوات وطرق القياس والتشخيص


خاتمة ومراجع عملية



1. مفاهيم أساسية
Frame: إطار عرض واحد. تطبيق سلس يحتاج إلى 60fps أو 120fps حسب الشاشة. 60fps يعني وقت لكل frame ≤ 16.66ms. إن تجاوزت هذه القيمة ستظهر تقطعات (jank).


Jank: تأخير في إنشاء أو عرض الإطار، يظهر كتقطيع أو تجمّد.


Main/UI thread: الخيط الذي ينفّذ القياسات (layout)، البنية (build) والرسم (paint) حتى مرحلة الـ raster.


Raster thread: خيط مستقل يقوم بتحويل الـ layers إلى bitmaps ورفعها للـ GPU.


Overdraw: رسم عدة طبقات متراكبة أكثر من اللازم، يرفع عبء GPU.


Rebuild vs Repaint vs Relayout:


Rebuild: تنفيذ build() وإعادة بناء شجرة الودجتس.


Relayout: إعادة حساب القياسات والمواقع.


Repaint: إعادة رسم البكسلات.


فهم الفرق مهم لتحديد مكان الخلل.

2. أنبوب الرسم في Flutter (rendering pipeline)
الخطوات الأساسية عند تحديث واجهة:
setState/Notifier event → يحدد أن هناك تغيير.


Build: استدعاء build() على الويدجتس المتأثرة.


Layout: حساب القياسات لأجزاء شجرة العناصر المتأثرة.


Compositing: تجهيز layers مع خصائص مثل opacity وtransform.


Paint: رسم كل layer على canvas في الـ Scene.


Raster: تحويل الـ Scene إلى صور (bitmaps) بواسطة raster thread.


GPU upload & Present: رفع textures إلى GPU وعرضها.


كل خطوة يمكن أن تسبب sobre-time. القياس الصحيح يحدد أي خطوة هي الزائدة.

3. فئات الأسباب: شائعة ونادرة
أسباب شائعة
Over-rebuild: setState على widget عالي يسبب rebuild لكامل الصفحة.


عمليات ثقيلة داخل build: parsing، تحويل صيغ، عمليات خاصة بالـ crypto أو IO داخل build.


صور كبيرة: تحميل صور بدقة كاملة ثم عمل fit/cover يؤدي إلى decoding مكثف.


قوائم غير Lazy: استخدام children بدل builder.


ثقل الـ layout: استخدام IntrinsicHeight/Width أو قياسات متكررة.


Animations كثيفة: الكثير من AnimationController أو listeners تعمل لكل عنصر.


Opacity & Clipping: Opacity ليس دائما رخيصا. ClipRRect يتطلب رسوم متكررة.


setState أثناء التمرير: كل ضغطة أو تغيير صغير يحدث setState يعيد بناء القائمة أثناء scroll.


أسباب نادرة لكنها مؤثرة
PlatformViews (مثل WebView, GoogleMap) تكسر composition وتؤثر على أداء GPU.


Textures/bitmaps كبيرة تملأ ذاكرة GPU وتبطئ raster.


Driver/GPU bugs في أجهزة محددة تتجسّد في overdraw أو slow texture upload.


Platform channel blocking: استدعاءات MethodChannel متزامنة تسبب حظر الـ UI.


Frequent MediaQuery changes: إعادة بناء كاملة عند تغيير أبعاد ناتجة عن إدخال لوحة مفاتيح متذبذب.



4. قياس الأداء وتشخيص الجانك (jank)
الخطوة الأولى ليست التعديل. هي القياس.
أدوات أساسية
DevTools Performance: record timeline, frames, raster thread.


profile/release mode: القياس يجب في profile أو release.


Flutter Observatory / Timeline: يفصل phases: Build, Layout, Paint, Raster.


repaint rainbow: يُظهر أي منطقة تعيد الطلاء باستمرار.


CPU & Memory profiler: يبحث عن GC spikes والallocations الكبيرة.


خطوات قياس منهجية
شغّل build في profile mode: flutter run --profile.


سجّل timeline أثناء حدوث Jank.


حدّد أي مراحل تتجاوز 16ms. إذا كانت Paint أو Layout فوق المسموح، ركّز عليها.


لاحظ allocations الكبيرة أثناء التمرير: العينات تعطي مؤشرًا على decode أو create objects.


شغّل repaint rainbow لتحديد overdraw أو repaint hotspots.


عدّل صغيراً ثم أعد القياس. القياس بعد كل تغيير مهم.



5. سياسات برمجة وأفضل ممارسات مفصلة
قاعدة أولى: اجعل Widget صغيرة ومسؤولة
كل widget يجب أن يكون مسؤولاً عن جزء صغير من الواجهة. إذا تغير شيء، فقط الـ widget المعني يُعاد بناؤه.


const everywhere
استخدم const لكل الأشياء الثابتة. const يمنع إعادة الإنشاء ويقلل GC.


فصل data/logic عن UI
لا تنفذ المعالجات في الـ build. استعمل bloc/cubit أو providers للتعامل مع البيانات.


استخدام ValueNotifier للعناصر الصغيرة
للعناصر المنفردة التي تحتاج تحديث سريع، ValueNotifier + ValueListenableBuilder أفضل من setState على parent.


RepaintBoundary
حول أجزاء كبيرة وثابتة داخل RepaintBoundary لتفادي إعادة طلاءها.


Avoid expensive layout widgets
تجنّب IntrinsicHeight/Width، LayoutBuilder في itemBuilder، واستخدم itemExtent إن أمكن.


Control list extents
استخدم itemExtent أو prototypeItem عند ثبات الحجم. يقلل cost of layout.


Limit depth of widget tree in list items
تقليل التعشيش يقلل cost to build and layout.



6. صور ووسائط: أساليب فعّالة
الصور عادةً أكبر سبب.
مبادئ
استخدم thumbnails: اعرض صورة أصغر في القائمة. الأصلية عند فتح التفاصيل.


cached_network_image: caching وplaceholder وprogress.


MemoryImage reuse: إذا لديك Uint8List استخدم MemoryImage مرة واحدة واحتفظ بالمصدر.


precacheImage: قبل عرض الشاشة استدعي precacheImage للصور المهمة.


resizeDecode: عند decode من مصدر، مرّر target width/height إن أمكن قبل decode.


Avoid decoding in build: decode image في isolate أو عند إضافة الصورة لأول مرة.


أمثلة تقنية
بدلاً من Image.memory(bytes) داخل itemBuilder، استخدم final provider = MemoryImage(bytes); خارج الـ build ومرّر provider للـ Image.



7. القوائم الكبيرة والـ Lazy Loading
استخدم ListView.builder أو GridView.builder.


إن كان لديك آلاف العناصر، استخدم Pagination أو PagedList.


ضع cacheExtent حسب الحاجة.


اجعل كل item widget const أو متغيرا بسيطاً.


إذا كان item يعتمد على بيانات متغيرة (مثلاً selection) اعزل الـ state داخل item.



8. إدارة الحالة وتأثيرها على إعادة البناء
Bloc/Cubit: استخدم selectors أو buildWhen لتقليل إعادة البناء.


Provider/Riverpod: استخدم selectors (context.select) لتحديد الحقول التي تبنى عند تغييرها.


setState: استخدمه داخل عنصر stateful صغير قدر الإمكان.


ValueNotifier: بسيط وفعال للعناصر الصغيرة.


Immutable models: مقارنة سريعة عند الحاجة لبناء مشروط.



9. الرسوم المتحركة والفيزوالز
استخدم ImplicitlyAnimatedWidget بدل إنشاء AnimationController لكل عنصر.


شارك vsync عندما تستعمل controllers.


اجعل الرسوم قصيرة وذات easing مناسب.


Delay per-index يضر الأداء. لا تضف delays كبيرة في itemBuilder.


عندما تحتاج تأثيرات كثيرة على عناصر متعددة، استخدم AnimatedList أو animate once on appear, وليس continuous.



10. العمليات الثقيلة وعزلها (Isolates, compute)
أي عملية CPU-heavy: image decoding, JSON parsing كبير، compression، encryption يجب أن تعمل في isolate.


استخدم compute() للتعامل السريع.


إذا العمليات متكررة استخدم worker isolate طويل العمر.


لا تشغّل isolates لكل عنصر على مستوى التمرير؛ نفّذ preprocessing offline أو عند تحميل الملف.



11. الذاكرة، الـ GC، وتسريبات الذاكرة
Allocations: تجنّب إنشاء كائنات كثيرة داخل loops.


GC spikes: تظهر كتقطيع. قلل allocations قصيرة العمر أثناء التمرير.


Leak detection: استخدم memory profiler وابحث عن grow-unbounded in heap.


تأكد من إغلاق controllers وStreamSubscriptions وHive boxes في dispose.



12. مشكلات GPU وTexture وPlatform Views
Texture upload heavy: large images → texture upload time يسبب frames miss.


اجعل الصور أصغر من حجم الشاشة إن أمكن.


PlatformViews (مثل Google Maps) تكسر الcompositing. حاول وضعها في شاشة منفصلة أو استخدم hybrid composition بعقلانية.


لا تضع many shadows and translucent layers on many items.



13. حالات دراسية واقعية وحلولها
حالة 1: GridView يتقطّع عند التمرير
سبب: Image.memory داخل build دون caching وAnimatedBuilder لكل عنصر.


حل: استخدم MemoryImage provider محفوظ، GalleryItem stateful، AnimatedScale بدل AnimatedBuilder، lazy decoding.


حالة 2: شاشة تسجل بطء عند تحديث عنصر favorite
سبب: BlocBuilder واحد على كل الشاشة.


حل: استخدم BlocBuilder per item أو buildWhen لفلترة التحديثات.


حالة 3: slow first frame
سبب: asset decoding أو expensive init داخل initState.


حل: defer expensive init إلى after first frame مع addPostFrameCallback أو precompute في splash.



14. قائمة فحص عملية قبل الإصدار
قياس الأداء في profile وrelease.


تسجيل Timeline أثناء التمرير.


التحقق من allocations أثناء استخدام التطبيق.


اختبار على أجهزة ضعيفة.


التحقق من استخدام الذاكرة والـ GPU textures.


استبدال heavy ops بعينات في background.


استخدام const وRepaintBoundary حسب الحاجة.


اختبار حالة الشبكة والـ images caching.


اختبار Accessibility وkeyboard show/hide reflows.



15. أدوات وطرق القياس والتشخيص
flutter run --profile


DevTools Performance tab


Observatory timeline exports


flutter build apk --split-per-abi --release للاختبار على أجهزة حقيقية


استخدام Timeline snapshots ومقارنتها بعد التعديل


flutter analyze للكود الثابت



16. مقتطفات كود عملية (نماذج سريعة)
1) تقليل rebuild عبر ValueNotifier
final ValueNotifier<Set<int>> selected = ValueNotifier({});

ValueListenableBuilder<Set<int>>(
  valueListenable: selected,
  builder: (_, set, __) => Icon(
    set.contains(index) ? Icons.check : Icons.check_box_outline_blank
  ),
);

2) استخدام MemoryImage provider خارج build
class GalleryItem extends StatelessWidget {
  final MemoryImage imageProvider;
  const GalleryItem({required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Image(image: imageProvider, fit: BoxFit.cover);
  }
}

3) استخدام compute لعزل decode
Future<Uint8List> decodeAndResize(Uint8List bytes, int width) {
  return compute(_decodeResize, {'bytes': bytes, 'width': width});
}

Uint8List _decodeResize(Map args) {
  // heavy decode and resize logic
}


17. قواعد ذهبية للتنفيذ اليومي
قياس قبل وبعد أي تغيير.


ابدأ بحلول بسيطة (itemExtent, const, caching) ثم اتجه لعزل. لأن أقل تغيير غالباً يعطي أكبر أثر.


اجعل الإنشاء الأولي خفيفًا. defer heavy work.


عند الشك، راجع الـ timeline بدلاً من التخمين.



الخاتمة
السلاسة في فلاتر ليست حالة سحرية. هي نتيجة عقيدة تصميم صحيحة: قياس مستمر، عزل للأعمال الثقيلة، تجزئة الـ UI، وإدارة ذكية للحالة والوسائط. اتبع القواعد أعلاه بطريقة منهجية وسترى تحسّن كبير في السلاسة حتى على أجهزة منخفضة الأداء.




أسباب شائعة لعدم السلاسة
إعادة بناء واسعة (over-rebuild). استخدام setState على الـ widget الأعلى أو BlocBuilder واحد لكل الشاشة.


عمليات ثقيلة على الـ main thread. parsing, crypto, فحص ملفات، ضغط أو فك صور داخل build.


صور غير مُهيئة. تحميل/فك صور بدقة كاملة بدون تصغير أو caching.


قوائم غير مبنية كسحبٍ كسول. استخدام ListView(children: [...]) بدلاً من ListView.builder أو GridView.builder.


عمليات layout مكلفة. IntrinsicWidth/Height, LayoutBuilder في كل عنصر، أو حسابات قياس متكررة.


طلاء و compositing مكلف. كثرة BoxShadow، ClipRRect، BackdropFilter، وطبقات شفافة كثيرة.


الرسوم المتحركة المفرطة أو غير المحصورة. عدّة AnimationController وتشغيلها لكل عنصر.


إعادة تحميل/إعادة decode للصور عند كل build. إنشاء Image.memory أو MemoryImage داخل build بدون إعادة استخدام.


setState أثناء الكتابة أو التمرير. تحديث الحالة حرفياً على كل ضغطة بدلاً من تجميع/تخفيف التحديثات.


أسباب غير شائعة لكن تسبب جّانك
إستنزاف GPU أو مشكلات درايفر جهاز محدد. (بعض الأجهزة تتأثر بظلال كثيفة أو أحجام textures كبيرة).


تداخل PlatformViews (مثلاً WebView/Map) مع الGPU. يؤدي لفقدان الـ composition.


تغييرات متكررة في MediaQuery (الكيبورد يفتح ويغلق) مع إعادة بناء كاملة.


استخدام مكتبات داخلية تقوم بعمليات متزامنة عبر platform channel.


أفضل سياسات برمجة تطبيقات فلاتر سلسة (قائمة عملية)
عام
اجعل كل widget صغير. كل widget مسؤول عن قطعة واحدة من UI.


const في كل مكان ممكن.


نفّذ قبول/رفض تغييرات الحالة محلياً. لا تُحدث الشاشة بأكملها.


قوائم وGrid
استخدم ListView.builder / GridView.builder.


حدد itemExtent أو cacheExtent متى أمكن. itemExtent يمنع قياسات متكررة.


استخدم pagination أو lazy loading لآلاف العناصر.


إذا تحتاج حفظ عنصر أثناء التنقل، استخدم AutomaticKeepAliveClientMixin.


الصور والوسائط
لا تعرض صور بدقة أعلى من المطلوب. احفظ/اطلب ثُم استخدم thumbnails.


استخدم مكتبات caching (مثلاً cached_network_image) أو احفظ thumbnails محلياً.


قم بـ pre-cache للصور المهمة بـ precacheImage قبل عرض الشاشة.


لا تفكّر بعمل decode ثقيل في build. انقله إلى isolate أو قم بإنشاء thumbnails مسبقاً.


إدارة الحالة
قسم الحالة بدقة. اجعل كل عنصر يستمع لتغيره فقط.


استخدم Bloc/Cubit أو Provider/Riverpod مع selectors (buildWhen / context.select) لتفادي إعادة بناء كاملة.


استخدم ValueNotifier/ValueListenableBuilder للعناصر الصغيرة وتحديثها محلياً.


الرسم والـ Layering
قلل من استخدام Opacity وBoxShadow في عناصر كثيرة.


ضع أجزاء ثابتة داخل RepaintBoundary لمنع إعادة طلاءها عند تغيّر أجزاء أخرى.


تجنب ClipRRect/ClipPath عندما لا يكون ضروريًا.


استخدم DecorationImage أو صورة مسطّحة بدلاً من رسم gradient ثقيل على كل إطار.


Animations
استخدم ImplicitlyAnimatedWidget (مثال: AnimatedOpacity, AnimatedScale) عندما يكفي.


احتفظ بعدد controllers منخفض. شارك vsync إن أمكن.


قلل دقة التوقيتات وابدأ/أنهِ الرسوم بعد الظهور بواسطة addPostFrameCallback.


الأعمال الثقيلة
استخدم compute() أو isolates لعمليات CPU-bound.


اجعل IO وعمليات التخزين asynchronous بعيدًا عن build.


تأجيل الأعمال غير اللازمة حتى بعد أول إطار (WidgetsBinding.instance.addPostFrameCallback).


Layout
تجنّب IntrinsicHeight/IntrinsicWidth.


لا تستخدم Expanded/Flexible بطرق تجبر على إعادة قياس مرّات.


استخدم const TextStyle و Theme لتقليل إعادة بناء.


تشخيص سريع (checklist) قبل التعديل
افتح DevTools → Performance → Timeline. راقب frames و jank.


شغّل التطبيق بـ profile أو release عند القياس.


فعّل repaint rainbow وراقب أي widgets تعيد الطلاء بكثرة.


سجل CPU profile أثناء scroll ثقيل. افحص main thread و raster thread.


ابحث عن allocations عالية أثناء التمرير (images, lists).


إصلاحات سريعة قابلة للتنفيذ الآن
استبدل setState الواسع بطرق محلية: ValueNotifier أو setState داخل عنصر فرعي.


حوّل صور عالية الدقة إلى thumbnails قبل العرض.


ضع RepaintBoundary حول header أو العناصر الثابتة:


RepaintBoundary(
  child: LargeStaticHeader(...),
)

في القوائم:


ListView.builder(
  itemCount: items.length,
  itemExtent: 80, // ثبات الارتفاع لتسريع layout
  itemBuilder: (context, i) => ItemWidget(items[i]),
)

استبدل AnimatedBuilder الثقيل بـ AnimatedScale/AnimatedOpacity.


لا تقم بأي decoding أو parsing داخل build.


مقتطف عملي: إخفاء إعادة البناء لعناصر الاختيار
class ItemWidget extends StatelessWidget {
  final Item item;
  const ItemWidget(this.item, {Key? key}): super(key: key);
  @override
  Widget build(BuildContext c) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(item.bytes, fit: BoxFit.cover),
      ),
    );
  }
}

اجعل اختيار العنصر state محلي داخل عنصر صغير أو عبر ValueNotifier ليُحدّث العنصر فقط.


