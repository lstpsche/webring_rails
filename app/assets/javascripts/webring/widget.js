/**
 * Webring Navigation Widget
 *
 * Usage:
 * <script src="https://yourhub.com/webring/widget.js" data-member-id="YOUR_MEMBER_ID"></script>
 * <div id="webring-widget"></div>
 */

(function() {
  // Get the current script element
  const scriptTag = document.currentScript || (function() {
    const scripts = document.getElementsByTagName('script');
    return scripts[scripts.length - 1];
  })();

  // Extract member ID from the data attribute
  const memberId = scriptTag.getAttribute('data-member-id');

  if (!memberId) {
    console.error('Webring Widget: Missing data-member-id attribute on script tag.');
    return;
  }

  // Base URL from the current script's src attribute
  const scriptSrc = scriptTag.getAttribute('src');
  const baseUrl = scriptSrc.substring(0, scriptSrc.lastIndexOf('/'));
  const rootUrl = baseUrl.substring(0, baseUrl.lastIndexOf('/'));

  // Function to create the widget HTML
  function createWidget() {
    const container = document.getElementById('webring-widget');
    if (!container) {
      console.error('Webring Widget: No element with id "webring-widget" found.');
      return;
    }

    // Create widget markup
    container.innerHTML = `
      <div class="webring-nav">
        <span class="webring-title">Webring</span>
        <nav>
          <a href="${rootUrl}/webring/previous?source_member_id=${memberId}" title="Previous site">«</a>
          <a href="${rootUrl}/webring/random?source_member_id=${memberId}" title="Random site">Random</a>
          <a href="${rootUrl}/webring/next?source_member_id=${memberId}" title="Next site">»</a>
        </nav>
      </div>
    `;

    // Add basic styles
    const style = document.createElement('style');
    style.textContent = `
      .webring-nav {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        font-size: 16px;
        display: flex;
        flex-direction: column;
        align-items: center;
        max-width: 350px;
        margin: 0 auto;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
      }

      .webring-title {
        font-weight: bold;
        margin-bottom: 8px;
      }

      .webring-nav nav {
        display: flex;
        gap: 15px;
      }

      .webring-nav a {
        text-decoration: none;
        color: #0066cc;
        transition: color 0.2s ease;
      }

      .webring-nav a:hover {
        color: #004499;
        text-decoration: underline;
      }
    `;
    container.appendChild(style);
  }

  // Wait for DOM to be ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', createWidget);
  } else {
    createWidget();
  }
})();
