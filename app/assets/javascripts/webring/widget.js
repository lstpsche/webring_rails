/**
 * Webring Navigation Widget
 *
 * Usage:
 * <script src="https://yourhub.com/widget.js" data-member-uid="YOUR_MEMBER_UID" data-widget-type="full"></script>
 * <div id="webring-widget"></div>
 *
 * For multiple widgets on same page:
 * <script src="https://yourhub.com/widget.js" data-member-uid="YOUR_MEMBER_UID" data-widget-type="full" data-target-id="custom-widget-id"></script>
 * <div id="custom-widget-id"></div>
 *
 * Widget Types:
 * - full: text, back btn, random btn, forward btn (default)
 * - no-text: back btn, random btn, forward btn (no text)
 * - two-way: back btn, forward btn (no random)
 * - one-way: forward btn only
 * - random-only: random btn only
 *
 * Additional Options:
 * - data-button-text="true|false": If true, buttons will show text labels. If false, only symbols are shown. Default: true
 * - data-styles="full|layout|none": Controls styling applied to the widget. Default: full
 *   - full: Apply all styles (default)
 *   - layout: Only layout styles, no visual design
 *   - none: No styles applied
 * - data-prev-text="Custom Text": Sets custom text for the "previous" button. Default: "« Prev"
 * - data-random-text="Custom Text": Sets custom text for the "random" button (keeps the logo). Default: "Random"
 * - data-next-text="Custom Text": Sets custom text for the "next" button. Default: "Next »"
 * - data-widget-text="Custom Text": Sets custom text for the widget title. Default: "Webring"
 */

(function() {
  // Configuration constants
  const WIDGET_CONFIG = Object.freeze({
    VALID_TYPES: Object.freeze(['full', 'no-text', 'two-way', 'one-way', 'random-only']),
    DEFAULT_TYPE: 'full',
    DEFAULT_TARGET_ID: 'webring-widget',
    STYLE_ID: 'webring-widget-styles',
    VALID_STYLE_TYPES: Object.freeze(['full', 'layout', 'none']),
    DEFAULT_STYLE_TYPE: 'full'
  });

  // Default text configurations
  const TEXT_DEFAULTS = Object.freeze({
    prev: { default: '« Prev', enforced: false },
    random: { default: 'Random', enforced: false },
    next: { default: 'Next »', enforced: false },
    widgetTitle: { default: 'Webring', enforced: false }
  });

  // These defaults will be provided by the widget_controller
  const PROVIDED_TEXT_DEFAULTS = "<<REPLACE_ME_TEXT_DEFAULTS>>";

  // Parse the provided defaults JSON string
  const parsedProvidedDefaults =
    PROVIDED_TEXT_DEFAULTS !== "<<REPLACE_ME_TEXT_DEFAULTS>>"
      ? (typeof PROVIDED_TEXT_DEFAULTS === 'string' ? JSON.parse(PROVIDED_TEXT_DEFAULTS) : PROVIDED_TEXT_DEFAULTS)
      : {};

  // Merge defaults with provided defaults
  const FULL_TEXT_DEFAULTS = Object.freeze(
    Object.keys(TEXT_DEFAULTS).reduce((acc, key) => {
      const providedValue = parsedProvidedDefaults[key];
      acc[key] = {
        default: providedValue?.default ?? TEXT_DEFAULTS[key].default,
        enforced: providedValue?.enforced ?? TEXT_DEFAULTS[key].enforced
      };
      return acc;
    }, {})
  );

  const logoSvg = (width = 20, height = 20, style = "") => `<<REPLACE_ME_LOGO_SVG>>`;

  const NAVIGATION_ACTIONS = Object.freeze({
    prev: {
      symbol: '«',
      text: `« ${FULL_TEXT_DEFAULTS.prev.default}`,
      text_enforced: FULL_TEXT_DEFAULTS.prev.enforced,
      title: 'Previous site',
      path: 'previous',
      additionalClass: 'prev-btn'
    },
    random: {
      symbol: logoSvg(23, 23),
      text: `${logoSvg(20, 20, "margin-right: 4px; margin-top: 1px;")} ${FULL_TEXT_DEFAULTS.random.default}`,
      text_enforced: FULL_TEXT_DEFAULTS.random.enforced,
      title: 'Random site',
      path: 'random',
      additionalClass: 'random-btn'
    },
    next: {
      symbol: '»',
      text: `${FULL_TEXT_DEFAULTS.next.default} »`,
      text_enforced: FULL_TEXT_DEFAULTS.next.enforced,
      title: 'Next site',
      path: 'next',
      additionalClass: 'next-btn'
    },
    logoOnly: {
      symbol: logoSvg(23, 23),
      text: logoSvg(23, 23),
      path: '',
      additionalClass: 'logo-only'
    }
  });

  const WIDGET_TYPE_CONFIG = Object.freeze({
    'full': { showTitle: true, actions: ['prev', 'random', 'next'] },
    'no-text': { showTitle: false, actions: ['prev', 'random', 'next'] },
    'two-way': { showTitle: false, actions: ['prev', 'logoOnly', 'next'], showLogoInMiddle: true },
    'one-way': { showTitle: false, actions: ['next'], showLogoInButton: true },
    'random-only': { showTitle: false, actions: ['random'] }
  });

  const STYLES = Object.freeze({
    layout: `
      .webring-nav {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        font-size: 16px;
        display: flex;
        flex-direction: column;
        align-items: center;
        max-width: 350px;
        margin: 0 auto;
        padding: 10px;
      }
      .webring-title {
        margin-bottom: 8px;
      }
      .webring-nav nav {
        display: flex;
        gap: 10px;
        width: 100%;
        justify-content: center;
        align-items: center;
      }
      .webring-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 6px 12px;
        text-decoration: none;
      }
      .random-btn {
        padding: 6px 8px;
      }
      .logo-only {
        padding: 8px 3px 6px 3px;
      }
      .webring-nav[data-widget-type="no-text"] {
        padding: 8px 10px;
      }
      .webring-nav[data-widget-type="one-way"] {
        max-width: 200px;
      }
      .webring-logo-inline {
        display: inline-block;
        vertical-align: middle;
        margin-right: 6px;
        margin-top: 1px;
      }
      [data-button-text="false"] .prev-btn {
        padding-top: 5px;
        padding-right: 12.5px;
      }
      [data-button-text="false"] .next-btn {
        padding-top: 5px;
        padding-left: 12.5px;
      }
    `,
    design: `
      .webring-nav[data-widget-type="full"] {
        border: 2.5px solid #000000;
      }
      .webring-title {
        font-weight: 600;
      }
      .webring-btn {
        text-wrap: nowrap;
        color: #000000;
        font-weight: 600;
        background-color: #ffffff;
        border: 2.5px solid #000000;
        transition: background-color 0.2s ease, color 0.2s ease;
      }
      .webring-btn:hover {
        background-color: #000000;
        color: #ffffff;
      }
      .webring-btn:focus {
        outline: none;
        background-color: transparent;
        color: #000000;
      }
      .webring-btn:active {
        border-color: #000000;
        background-color: #000000;
        color: #ffffff;
      }
    `
  });

  // Track if styles have been applied
  let stylesApplied = false;

  // Run immediately for widget initialization
  createWidget();

  function createWidget(scriptElement) {
    // Find the script element, using a passed element, current script, or last script
    const script = scriptElement || document.currentScript || document.getElementsByTagName('script')[document.getElementsByTagName('script').length - 1];

    if (!script) return;

    // Config from data attributes
    const memberUid = script.getAttribute('data-member-uid');
    const widgetType = script.getAttribute('data-widget-type') ?? WIDGET_CONFIG.DEFAULT_TYPE;
    const targetId = script.getAttribute('data-target-id') ?? WIDGET_CONFIG.DEFAULT_TARGET_ID;
    const buttonText = script.getAttribute('data-button-text') !== 'false';
    const stylesType = script.getAttribute('data-styles') ?? WIDGET_CONFIG.DEFAULT_STYLE_TYPE;
    const stylesOption = WIDGET_CONFIG.VALID_STYLE_TYPES.includes(stylesType) ? stylesType : WIDGET_CONFIG.DEFAULT_STYLE_TYPE;

    // Custom text data attributes
    const prevText = script.getAttribute('data-prev-text');
    const randomText = script.getAttribute('data-random-text');
    const nextText = script.getAttribute('data-next-text');
    const widgetText = script.getAttribute('data-widget-text');

    if (!memberUid) {
      console.error('Webring Widget: Missing data-member-uid attribute on script tag.');
      return;
    }

    if (!WIDGET_CONFIG.VALID_TYPES.includes(widgetType)) {
      console.error(`Webring Widget: Invalid widget type "${widgetType}". Valid types: ${WIDGET_CONFIG.VALID_TYPES.join(', ')}`);
      return;
    }

    const scriptSrc = script.getAttribute('src');
    const baseUrl = new URL(scriptSrc, window.location.href).origin;

    const renderWidget = function() {
      const container = document.getElementById(targetId);
      if (!container) {
        console.error(`Webring Widget: No element with id "${targetId}" found.`);
        return;
      }

      // Apply styles only once per page
      if (!stylesApplied) {
        applyStyles(stylesOption);
        stylesApplied = true;
      }

      // Use DocumentFragment for DOM operations
      const fragment = document.createDocumentFragment();

      // Create main wrapper div
      const wrapperDiv = document.createElement('div');
      wrapperDiv.className = 'webring-nav';
      wrapperDiv.setAttribute('data-widget-type', widgetType);
      wrapperDiv.setAttribute('data-button-text', buttonText.toString());

      // Apply custom texts efficiently
      const customTexts = {
        prev: NAVIGATION_ACTIONS.prev.text_enforced
              ? NAVIGATION_ACTIONS.prev
              : (prevText ? {...NAVIGATION_ACTIONS.prev, text: `« ${prevText}`} : NAVIGATION_ACTIONS.prev),
        random: NAVIGATION_ACTIONS.random.text_enforced
                ? NAVIGATION_ACTIONS.random
                : (randomText ? {...NAVIGATION_ACTIONS.random, text: `${logoSvg(20, 20, "margin-right: 4px; margin-top: 1px;")} ${randomText}`} : NAVIGATION_ACTIONS.random),
        next: NAVIGATION_ACTIONS.next.text_enforced
              ? NAVIGATION_ACTIONS.next
              : (nextText ? {...NAVIGATION_ACTIONS.next, text: `${nextText} »`} : NAVIGATION_ACTIONS.next),
        logoOnly: NAVIGATION_ACTIONS.logoOnly
      };

      // Add title if needed
      const config = WIDGET_TYPE_CONFIG[widgetType];
      if (config.showTitle) {
        const titleElem = document.createElement('span');
        titleElem.className = 'webring-title';
        titleElem.innerHTML = FULL_TEXT_DEFAULTS.widgetTitle.enforced ?
          FULL_TEXT_DEFAULTS.widgetTitle.default :
          (widgetText ?? FULL_TEXT_DEFAULTS.widgetTitle.default);
        wrapperDiv.appendChild(titleElem);
      }

      // Create navigation container
      const navElem = document.createElement('nav');
      navElem.className = 'webring-buttons';

      // Create buttons
      config.actions.forEach(action => {
        const actionConfig = customTexts[action];

        // Logo-only block
        if (action === 'logoOnly') {
          const logoDiv = document.createElement('div');
          logoDiv.className = actionConfig.additionalClass;
          logoDiv.innerHTML = actionConfig.symbol;
          navElem.appendChild(logoDiv);
          return;
        }

        const linkElem = document.createElement('a');
        linkElem.href = `${baseUrl}/webring/${actionConfig.path}?source_member_uid=${memberUid}`;
        linkElem.title = actionConfig.title;
        linkElem.className = `webring-btn ${actionConfig.additionalClass}`;

        // One-way type case
        if (widgetType === 'one-way' && config.showLogoInButton && action === 'next') {
          const buttonTextContent = NAVIGATION_ACTIONS.next.text_enforced ?
            FULL_TEXT_DEFAULTS.next.default :
            (nextText || customTexts.next.text.replace(' »', ''));

          linkElem.innerHTML = buttonText
            ? `<span class="webring-logo-inline">${logoSvg(20, 20)}</span> ${buttonTextContent} »`
            : `<span class="webring-logo-inline">${logoSvg(20, 20)}</span> ${actionConfig.symbol}`;
        } else {
          linkElem.innerHTML = buttonText ? actionConfig.text : actionConfig.symbol;
        }

        navElem.appendChild(linkElem);
      });

      wrapperDiv.appendChild(navElem);
      fragment.appendChild(wrapperDiv);

      container.innerHTML = '';
      container.appendChild(fragment);
    };

    function applyStyles(styleOption) {
      let styleElement = document.getElementById(WIDGET_CONFIG.STYLE_ID);
      if (!styleElement) {
        styleElement = document.createElement('style');
        styleElement.id = WIDGET_CONFIG.STYLE_ID;
        document.head.appendChild(styleElement);
      }

      switch (styleOption) {
        case 'none':
          styleElement.textContent = '';
          break;
        case 'layout':
          styleElement.textContent = STYLES.layout;
          break;
        default: // 'full'
          styleElement.textContent = STYLES.layout + STYLES.design;
      }
    }

    // Run immediately or wait for DOM
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', renderWidget);
    } else {
      renderWidget();
    }
  }
})();
