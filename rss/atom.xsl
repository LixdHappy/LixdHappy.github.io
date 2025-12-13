<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <xsl:variable name="title">
      <xsl:value-of select="/atom:feed/atom:title"/>
    </xsl:variable>
    <xsl:variable name="description">
      <xsl:value-of select="/atom:feed/atom:subtitle"/>
    </xsl:variable>
    <xsl:variable name="link">
      <xsl:value-of select="/atom:feed/atom:link[@rel='alternate']/@href | /atom:feed/atom:link[not(@rel)]/@href"/>
    </xsl:variable>

    <html>
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>
          <xsl:value-of select="$title"/>
 - GBの订阅源</title>
        <style>
          :root {
            --bg-color: #f8fafc;
            --text-color: #1e293b;
            --card-bg:rgba(255, 255, 255, 0.8);
            --border-color: #e2e8f0;
            --accent-color: #4f46e5;
            --muted-color: #64748b;
            --overlay: rgba(255, 255, 255, 0.5);
            --header-text-light: #1f2937;
            --header-muted-light: #6b7280;
            --subscribe-bg-light: #f3f4f6;

            --header-text-dark: #f3f4f6;
            --header-muted-dark: #9ca3af;
            --subscribe-bg-dark: #1f2937;
            
            --header-text: var(--header-text-light);
            --header-muted: var(--header-muted-light);
            --subscribe-bg: var(--subscribe-bg-light);
          }
          
          @media (prefers-color-scheme: dark) {
            :root {
              --bg-color: #0f172a;
              --text-color: #f8fafc;
              --card-bg:rgba(30, 41, 59, 0.8);
              --border-color: #334155;
              --accent-color: #818cf8;
              --muted-color: #94a3b8;
              --overlay: rgba(15, 23, 42, 0.5);
              --header-text: var(--header-text-dark);
              --header-muted: var(--header-muted-dark);
              --subscribe-bg: var(--subscribe-bg-dark);
            }
          }
          
          * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
          }
          
          body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            line-height: 1.5;
            color: var(--text-color);
            background-color: var(--bg-color);
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
            background-image: url('https://bing.gbfun.cc/daily.webp');
            background-size: cover;
            background-attachment: fixed;
            background-position: center;
          }
          
          body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: var(--overlay);
            backdrop-filter: blur(5px);
            z-index: -1;
          }
          
          a {
            color: var(--accent-color);
            text-decoration: none;
          }
          
          a:hover {
            text-decoration: underline;
          }
          
          .container {
            width: 100%;
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem 1rem;
          }
          
          .header {
            padding: 2rem 0;
            color: var(--header-text);
            text-align: left;
            max-width: 800px;
            margin: 0 auto;
          }

          .header-top {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px dashed var(--header-text);
          }

          .header-avatar svg {
            flex-shrink: 0;
            color: var(--header-text);
          }

          .header-title {
            font-size: 1.75rem;
            font-weight: 700;
          }

          .header-description-cn,
          .header-description-en {
            margin-bottom: 1rem;
            font-size: 1rem;
            color: var(--header-text);
            line-height: 1.6;
          }

          .header-subscribe {
            margin-top: 2rem;
            padding: 1rem;
            background: var(--subscribe-bg);
            border-radius: 0.5rem;
            border-left: 4px solid var(--header-text);
            font-size: 0.95rem;
            color: var(--header-muted);
          }

          .header-subscribe a {
            color: var(--header-text);
            font-weight: bold;
            text-decoration: underline;
            transition: color 0.3s ease;
          }

          .header-subscribe a:hover {
            color:rgb(9, 147, 197);
          }
          
          .article-list {
            display: grid;
            gap: 1.5rem;
          }
          
          .article-card {
            background-color: var(--card-bg);
            backdrop-filter: blur(5px);
            border-radius: 0.8rem;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--border-color);
            transition: transform 0.2s, box-shadow 0.2s;
          }
          
          .article-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
          }
          
          .article-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
          }
          
          .article-meta {
            display: flex;
            gap: 1rem;
            color: var(--muted-color);
            font-size: 0.875rem;
            margin-bottom: 1rem;
          }
          
          .article-summary {
            margin-bottom: 1rem;
            color: var(--text-color);
          }
          
          .article-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-top: 1rem;
          }
          
          .tag {
            background-color: var(--border-color);
            color: var(--text-color);
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
          }
          
          .footer {
            margin-top: 3rem;
            padding: 2rem 1rem;
            text-align: center;
            color: var(--muted-color);
            font-size: 1.0rem;
            transition: color 0.2s ease-in-out;
          }

          .footer-line {
            margin: 0.5rem 0;
          }

          .footer-line a, .footer-line span {
            color: var(--muted-color, #6b7280);
            text-decoration: none;
            margin: 0 0.5rem;
            transition: color 0.3s ease;
          }

          .footer-line a:hover {
            color:rgb(50, 124, 189);
          }

          .footer-line span {
            user-select: none;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <header class="header">
            <div class="header-top">
              <div class="header-avatar">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="40" height="40">
                  <circle cx="6" cy="18" r="2"></circle>
                  <path d="M4 4a16 16 0 0 1 16 16"></path>
                  <path d="M4 11a9 9 0 0 1 9 9"></path>
                </svg>
              </div>
              <h1 class="header-title">
                <xsl:value-of select="$title" disable-output-escaping="yes"/>
              </h1>
            </div>

            <p class="header-description-cn">
    来自GB的技术博客，提供生活点滴、科技钻研，个人经验，融合技术开发与人文思考，懒癌不发作时更新深度指南与创意灵感，给大家提供更多帮助。
            </p>
            <p class="header-description-en">
    Tech musings &amp; life bits from GB — where code meets coffee, and laziness occasionally takes a day off.
            </p>

            <div class="header-subscribe">
              <p>
      你可以使用 RSS 阅读器比如：
                <a href="https://feedly.com/i/subscription/feed/{$link}" target="_blank" rel="noopener noreferrer">Feedly</a>,
                <a href="https://www.inoreader.com/feed/{$link}" target="_blank" rel="noopener noreferrer">Inoreader</a>,
                <a href="https://www.newsblur.com/?url={$link}" target="_blank" rel="noopener noreferrer">Newsblur</a>,
                <a href="follow://add?url={$link}" rel="noopener noreferrer">Follow</a> 或者
                <a href="feed:{$link}" rel="noopener noreferrer">RSS Reader</a> 等工具，来订阅这个 RSS 源链接。
              </p>
            </div>
          </header>

          <div class="article-list">
            <xsl:for-each select="/atom:feed/atom:entry">
              <article class="article-card">
                <h2 class="article-title">
                  <a href="{atom:link/@href}" target="_blank">
                    <xsl:value-of select="atom:title" disable-output-escaping="yes"/>
                  </a>
                </h2>
                <div class="article-meta">
                  <time>
                    <xsl:value-of select="substring(atom:published, 1, 10)"/>
                  </time>
                  <span>·</span>
                  <span>
                    <xsl:value-of select="atom:category/@term"/>
                  </span>
                </div>
                <p class="article-summary">
                  <xsl:value-of select="atom:summary" disable-output-escaping="yes"/>
                </p>
                <xsl:if test="atom:category">
                  <div class="article-tags">
                    <xsl:for-each select="atom:category">
                      <span class="tag">
                        <xsl:value-of select="@term"/>
                      </span>
                    </xsl:for-each>
                  </div>
                </xsl:if>
              </article>
            </xsl:for-each>
          </div>

          <footer class="footer">
            <div class="footer-line">
              <span>© 2022-Now • LixdHappy</span>
            </div>
            <div class="footer-line">
              <span>本项目由Hexo自动爬取生成</span>
              <span>•</span>
              <a href="https://blog.gbfun.cc/" target="_blank" rel="nofollow noopener noreferrer">GB的记事簿📒</a>
            </div>
            <div class="footer-line">
              <span>本站壁纸由</span>
              <a href="https://bing.gbfun.cc/" target="_blank" rel="nofollow noopener noreferrer">Bing每日一图</a>
              <span>提供</span>
            </div>
          </footer>

        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>