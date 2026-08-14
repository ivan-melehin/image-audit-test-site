# Image-Audit Test Site v2

Тестовый статический сайт для проекта Image-Audit.

## Что изменено

Теперь все 15 мест под изображения используют настоящий HTML-тег:

```html
<img src="images/image_1.png" alt="..." title="..." width="800" height="600">
```

Изображения НЕ включены в архив специально. Это позволяет самостоятельно положить тестовые файлы в папку `images/`.

## Структура

```text
image-audit-test-site-v2/
├── index.html
├── about.html
├── catalog.html
├── README.md
└── images/
    └── сюда положить image_1.png ... image_15.png
```

## Как добавить картинки

Положите файлы в `images/`:

```text
images/
├── image_1.png
├── image_2.png
├── ...
└── image_15.png
```

Имена должны совпадать с именами в HTML.

## Важный тест для Image-Audit

Для проверки дубликатов можно специально сделать:

- image_1.png и image_6.png — одинаковыми;
- image_2.png и image_7.png — разными файлами, но одной фотографией после изменения размера;
- image_3.png — уникальным;
- image_4.png — уникальным;
- image_5.png — уникальным.

Тогда Image-Audit сможет протестировать SHA-256 и perceptual hash.

## GitHub Pages

1. Создайте Public repository `image-audit-test-site`.
2. Загрузите HTML-файлы и папку `images`.
3. Откройте Settings → Pages.
4. В Build and deployment выберите Deploy from a branch.
5. Branch: `main`.
6. Folder: `/ (root)`.
7. Нажмите Save.
8. Откройте выданный GitHub Pages URL.

## Локальный запуск

Можно открыть `index.html` напрямую. Для тестирования crawler лучше запустить локальный HTTP-сервер:

```bash
npx serve .
```

После этого откройте адрес, который покажет команда.
