/**
 * Webring Navigation Widget
 *
 * Usage:
 * <script src="https://yourhub.com/webring/widget.js" data-member-uid="YOUR_MEMBER_UID" data-widget-type="full"></script>
 * <div id="webring-widget"></div>
 *
 * For multiple widgets on same page:
 * <script src="https://yourhub.com/webring/widget.js" data-member-uid="YOUR_MEMBER_UID" data-widget-type="full" data-target-id="custom-widget-id"></script>
 * <div id="custom-widget-id"></div>
 *
 * Widget Types:
 * - full: text, back btn, random btn, forward btn (default)
 * - no-text: back btn, random btn, forward btn (no text)
 * - two-way: back btn, forward btn (no random)
 * - one-way: forward btn only
 *
 * Additional Options:
 * - data-button-text="true|false": If true, buttons will show text labels. If false, only symbols are shown. Default: true
 * - data-styles="full|layout|none": Controls styling applied to the widget. Default: full
 *   - full: Apply all styles (default)
 *   - layout: Only layout styles, no visual design
 *   - none: No styles applied
 */

(function() {
  // Configuration constants
  const WIDGET_CONFIG = {
    VALID_TYPES: ['full', 'no-text', 'two-way', 'one-way'],
    DEFAULT_TYPE: 'full',
    DEFAULT_TARGET_ID: 'webring-widget',
    STYLE_ID: 'webring-widget-styles',
    VALID_STYLE_TYPES: ['full', 'layout', 'none'],
    DEFAULT_STYLE_TYPE: 'full'
  };

  const NAVIGATION_ACTIONS = {
    prev: {
      symbol: '«',
      text: '« Prev',
      title: 'Previous site',
      path: 'previous'
    },
    random: {
      symbol: '⚡',
      text: 'Random',
      title: 'Random site',
      path: 'random'
    },
    next: {
      symbol: '»',
      text: 'Next »',
      title: 'Next site',
      path: 'next'
    }
  };

  const WIDGET_TYPE_CONFIG = {
    'full': { showTitle: true, actions: ['prev', 'random', 'next'] },
    'no-text': { showTitle: false, actions: ['prev', 'random', 'next'] },
    'two-way': { showTitle: false, actions: ['prev', 'next'] },
    'one-way': { showTitle: false, actions: ['next'] }
  };

  // Define styles outside the function to avoid duplication
  const STYLES = {
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
      }
      .webring-nav a.webring-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 6px 12px;
        text-decoration: none;
      }
      .webring-nav[data-widget-type="no-text"] {
        padding: 8px 10px;
      }
      .webring-nav[data-widget-type="one-way"] {
        max-width: 200px;
      }
      .webring-nav[data-widget-type="one-way"] nav {
        justify-content: center;
      }
    `,
    design: `
      .webring-nav[data-widget-type="full"] {
        border: 2.5px solid #000000;
      }
      .webring-title {
        font-weight: 600;
      }
      .webring-nav a.webring-btn {
        color: #000000;
        font-weight: 600;
        background-color: #ffffff;
        border: 2.5px solid #000000;
        transition: background-color 0.2s ease, color 0.2s ease;
      }
      .webring-nav a.webring-btn:hover {
        background-color: #000000;
        color: #ffffff;
      }
      .webring-nav a.webring-btn:focus {
        outline: none;
        background-color: transparent;
        color: #000000;
      }
      .webring-nav a.webring-btn:active {
        border-color: #000000;
        background-color: #000000;
        color: #ffffff;
      }
    `
  };

  // Run immediately for widget initialization
  createWidget();

  function createWidget(scriptElement) {
    const script = scriptElement || document.currentScript || (function() {
      const scripts = document.getElementsByTagName('script');
      return scripts[scripts.length - 1];
    })();

    if (!script) return;

    // Config from data attributes
    const memberUid = script.getAttribute('data-member-uid');
    const widgetType = script.getAttribute('data-widget-type') || WIDGET_CONFIG.DEFAULT_TYPE;
    const targetId = script.getAttribute('data-target-id') || WIDGET_CONFIG.DEFAULT_TARGET_ID;
    const buttonText = script.getAttribute('data-button-text') !== 'false';
    const stylesType = script.getAttribute('data-styles') || WIDGET_CONFIG.DEFAULT_STYLE_TYPE;
    const stylesOption = WIDGET_CONFIG.VALID_STYLE_TYPES.includes(stylesType) ? stylesType : WIDGET_CONFIG.DEFAULT_STYLE_TYPE;

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

      // Navigation links
      const config = WIDGET_TYPE_CONFIG[widgetType];
      const linkElements = config.actions.map(action => {
        const actionConfig = NAVIGATION_ACTIONS[action];
        const url = `${baseUrl}/webring/${actionConfig.path}?source_member_uid=${memberUid}`;
        const label = buttonText ? actionConfig.text : actionConfig.symbol;
        return `<a href="${url}" title="${actionConfig.title}" class="webring-btn">${label}</a>`;
      }).join('\n          ');

      // Create widget HTML
      const title = config.showTitle ? '<span class="webring-title">Webring</span>' : '';
      container.innerHTML = `
        <div class="webring-nav" data-widget-type="${widgetType}">
          ${title}
          <nav class="webring-buttons">
            ${linkElements}
          </nav>
        </div>
      `;

      applyStyles(stylesOption);
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
