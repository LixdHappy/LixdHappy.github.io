<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <xsl:variable name="title">
      <xsl:value-of select="/atom:feed/atom:title"/>
    </xsl:variable>
    <xsl:variable name="subtitle">
      <xsl:value-of select="/atom:feed/atom:subtitle"/>
    </xsl:variable>
    <xsl:variable name="updated">
      <xsl:value-of select="/atom:feed/atom:entry[1]/atom:published"/>
    </xsl:variable>
    <xsl:variable name="rights">
      <xsl:value-of select="/atom:feed/atom:rights"/>
    </xsl:variable>
    <xsl:variable name="link">
      <xsl:choose>
        <xsl:when test="/atom:feed/atom:link[@rel='alternate'][1]/@href">
          <xsl:value-of select="/atom:feed/atom:link[@rel='alternate'][1]/@href"/>
        </xsl:when>
        <xsl:when test="/atom:feed/atom:link[not(@rel)][1]/@href">
          <xsl:value-of select="/atom:feed/atom:link[not(@rel)][1]/@href"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/atom:feed/atom:link[1]/@href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="heroCover">
      <xsl:choose>
        <xsl:when test="/atom:feed/atom:entry[1]/atom:link[@rel='enclosure' and starts-with(@type, 'image/')][1]/@href">
          <xsl:value-of select="/atom:feed/atom:entry[1]/atom:link[@rel='enclosure' and starts-with(@type, 'image/')][1]/@href"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/atom:feed/atom:entry[1]/atom:link[@rel='enclosure'][1]/@href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <html lang="zh-CN">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="$title"/> - GBの订阅源</title>
        <style>
          :root {
            --page-bg: #f5f7fb;
            --text-main: #1f2937;
            --text-soft: #667085;
            --text-faint: #94a3b8;
            --accent: #7b92f8;
            --accent-deep: #5e78f2;
            --shadow-xl: 0 24px 70px rgba(148, 163, 184, 0.16);
            --shadow-lg: 0 12px 36px rgba(148, 163, 184, 0.14);
            --radius-xl: 30px;
            --radius-lg: 24px;
            --radius-md: 18px;
            --radius-pill: 999px;
          }

          * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
          }

          html,
          body {
            min-height: 100%;
          }

          body {
            font-family: "Inter", "SF Pro Display", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", sans-serif;
            color: var(--text-main);
            background-color: var(--page-bg);
            background-image: url('https://bing.gbfun.cc/daily.webp');
            background-position: center;
            background-size: cover;
            background-attachment: fixed;
            -webkit-font-smoothing: antialiased;
            text-rendering: optimizeLegibility;
            overflow-x: hidden;
          }

          body::before {
            content: "";
            position: fixed;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(180deg, rgba(255, 255, 255, 0.82) 0%, rgba(255, 255, 255, 0.88) 44%, rgba(248, 250, 252, 0.93) 100%);
            backdrop-filter: blur(18px) saturate(120%);
            -webkit-backdrop-filter: blur(18px) saturate(120%);
            z-index: -2;
          }

          body::after {
            content: "";
            position: fixed;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background:
              radial-gradient(circle at 12% 18%, rgba(255, 255, 255, 0.76), transparent 28%),
              radial-gradient(circle at 84% 14%, rgba(214, 228, 255, 0.42), transparent 24%),
              radial-gradient(circle at 80% 78%, rgba(255, 232, 241, 0.24), transparent 22%);
            z-index: -1;
            pointer-events: none;
          }

          a {
            color: inherit;
            text-decoration: none;
          }

          img {
            display: block;
            max-width: 100%;
            border: 0;
          }

          .shell {
            width: min(1080px, calc(100% - 28px));
            margin: 0 auto;
            padding: 22px 0 36px;
          }

          .hero {
            position: relative;
            overflow: hidden;
            padding: 22px;
            border-radius: var(--radius-xl);
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.72), rgba(255, 255, 255, 0.42));
            border: 1px solid rgba(255, 255, 255, 0.72);
            box-shadow: var(--shadow-xl);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
          }

          .hero::before {
            content: "";
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background:
              radial-gradient(circle at top left, rgba(255, 255, 255, 0.72), transparent 34%),
              linear-gradient(120deg, rgba(123, 146, 248, 0.08), rgba(255, 255, 255, 0));
            pointer-events: none;
          }

          .hero-main,
          .article-main,
          .article-cover {
            position: relative;
            z-index: 1;
          }

          .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 9px 14px;
            border-radius: var(--radius-pill);
            background: rgba(255, 255, 255, 0.58);
            border: 1px solid rgba(255, 255, 255, 0.74);
            color: var(--text-soft);
            font-size: 11px;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            box-shadow: var(--shadow-lg);
          }

          .eyebrow-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: linear-gradient(135deg, #bfd0ff, #88a4ff);
            box-shadow: 0 0 0 6px rgba(136, 164, 255, 0.12);
          }

          .hero-title {
            margin-top: 18px;
            font-size: clamp(2rem, 5vw, 3.8rem);
            line-height: 1.05;
            letter-spacing: -0.04em;
            font-weight: 700;
          }

          .hero-subtitle {
            margin-top: 14px;
            max-width: 680px;
            color: var(--text-soft);
            font-size: 15px;
            line-height: 1.85;
          }

          .hero-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 20px;
          }

          .meta-pill {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 10px 14px;
            border-radius: var(--radius-pill);
            background: rgba(255, 255, 255, 0.62);
            border: 1px solid rgba(255, 255, 255, 0.76);
            color: var(--text-soft);
            font-size: 13px;
            box-shadow: var(--shadow-lg);
          }

          .meta-pill strong {
            color: var(--text-main);
            font-weight: 600;
          }

          .subscribe {
            margin-top: 20px;
            padding: 16px 18px;
            border-radius: var(--radius-lg);
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.76), rgba(255, 255, 255, 0.52));
            border: 1px solid rgba(255, 255, 255, 0.82);
            box-shadow: var(--shadow-lg);
          }

          .subscribe-title {
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 8px;
          }

          .subscribe-desc {
            color: var(--text-soft);
            font-size: 14px;
            line-height: 1.8;
          }

          .subscribe-links,
          .footer-links,
          .article-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
          }

          .subscribe-links {
            margin-top: 14px;
          }

          .subscribe-link,
          .footer-link,
          .article-chip {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 34px;
            padding: 0 12px;
            border-radius: var(--radius-pill);
            background: rgba(255, 255, 255, 0.72);
            border: 1px solid rgba(255, 255, 255, 0.84);
            color: var(--text-main);
            font-size: 13px;
            box-shadow: 0 8px 24px rgba(148, 163, 184, 0.08);
            transition: transform 0.25s ease, border-color 0.25s ease, box-shadow 0.25s ease, color 0.25s ease;
          }

          .subscribe-link:hover,
          .footer-link:hover,
          .article-chip:hover,
          .article-category:hover {
            transform: translateY(-2px);
            border-color: rgba(123, 146, 248, 0.34);
            box-shadow: 0 14px 28px rgba(123, 146, 248, 0.1);
            color: var(--accent-deep);
          }


          .section-head {
            display: flex;
            align-items: end;
            justify-content: space-between;
            gap: 16px;
            margin: 26px 2px 14px;
          }

          .section-title {
            font-size: 20px;
            font-weight: 650;
            letter-spacing: -0.02em;
          }

          .section-note {
            color: var(--text-faint);
            font-size: 13px;
          }

          .article-list {
            display: grid;
            gap: 14px;
          }

          .article-card.is-hidden {
            display: none;
          }

          .article-card {
            position: relative;
            overflow: hidden;
            min-height: 220px;
            padding: 18px 18px 16px;
            border-radius: var(--radius-lg);
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.78), rgba(255, 255, 255, 0.5));
            border: 1px solid rgba(255, 255, 255, 0.84);
            box-shadow: var(--shadow-lg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            transition: transform 0.28s ease, box-shadow 0.28s ease, border-color 0.28s ease;
          }

          .article-card:hover {
            transform: translateY(-3px);
            border-color: rgba(123, 146, 248, 0.24);
            box-shadow: 0 18px 40px rgba(148, 163, 184, 0.16);
          }

          .article-main {
            position: relative;
            z-index: 2;
            width: min(62%, 620px);
          }

          .article-cover {
            position: absolute;
            top: 0;
            right: 0;
            bottom: 0;
            width: 54%;
            z-index: 1;
            pointer-events: none;
          }

          .cover-box {
            position: relative;
            overflow: hidden;
            display: block;
            width: 100%;
            height: 100%;
            border-radius: 0 var(--radius-lg) var(--radius-lg) 0;
            pointer-events: auto;
          }

          .cover-image,
          .cover-fallback {
            width: 100%;
            height: 100%;
          }

          .cover-image {
            object-fit: cover;
            object-position: center;
            filter: saturate(1.03) brightness(1.02);
          }

          .cover-fallback {
            background:
              radial-gradient(circle at 22% 22%, rgba(206, 220, 255, 0.82), transparent 22%),
              radial-gradient(circle at 76% 30%, rgba(255, 229, 240, 0.65), transparent 20%),
              linear-gradient(135deg, #f8fbff, #eff4ff 58%, #f9f5ff);
          }

          .cover-sheen {
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background:
              linear-gradient(90deg, rgba(255,255,255,0.96) 0%, rgba(255,255,255,0.84) 22%, rgba(255,255,255,0.42) 44%, rgba(255,255,255,0.06) 68%, rgba(255,255,255,0) 100%),
              linear-gradient(180deg, rgba(255,255,255,0.08), rgba(255,255,255,0.18));
            pointer-events: none;
          }

          .article-topline {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 8px;
            color: var(--text-faint);
            font-size: 12px;
          }

          .article-category {
            display: inline-flex;
            align-items: center;
            min-height: 32px;
            padding: 0 11px;
            border-radius: var(--radius-pill);
            background: rgba(123, 146, 248, 0.08);
            border: 1px solid rgba(123, 146, 248, 0.14);
            color: var(--accent-deep);
            transition: transform 0.25s ease, border-color 0.25s ease, box-shadow 0.25s ease, color 0.25s ease;
          }

          .article-title {
            margin-top: 12px;
            font-size: 23px;
            line-height: 1.32;
            font-weight: 650;
            letter-spacing: -0.02em;
          }

          .article-title a:hover {
            color: var(--accent-deep);
          }

          .article-summary {
            margin-top: 12px;
            color: var(--text-soft);
            line-height: 1.82;
            font-size: 14px;
          }

          .article-tags {
            margin-top: 14px;
          }

          .footer {
            margin-top: 24px;
            padding: 10px 0 2px;
            text-align: center;
            color: var(--text-soft);
          }

          .more-wrap {
            display: flex;
            justify-content: center;
            margin-top: 16px;
          }

          .more-button,
          .more-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 38px;
            padding: 0 16px;
            border-radius: var(--radius-pill);
            background: rgba(255, 255, 255, 0.76);
            border: 1px solid rgba(255, 255, 255, 0.86);
            color: var(--text-main);
            font-size: 13px;
            box-shadow: 0 8px 24px rgba(148, 163, 184, 0.08);
            transition: transform 0.25s ease, border-color 0.25s ease, box-shadow 0.25s ease, color 0.25s ease;
          }

          .more-button {
            cursor: pointer;
            appearance: none;
            -webkit-appearance: none;
          }

          .more-button:hover,
          .more-link:hover {
            transform: translateY(-2px);
            border-color: rgba(123, 146, 248, 0.34);
            box-shadow: 0 14px 28px rgba(123, 146, 248, 0.1);
            color: var(--accent-deep);
          }

          .footer-meta {
            font-size: 13px;
            line-height: 1.9;
          }

          .footer-links {
            justify-content: center;
            margin-top: 12px;
          }

          @media (max-width: 980px) {
            .article-main {
              width: 100%;
            }

            .article-cover {
              width: 58%;
            }
          }

          @media (max-width: 720px) {
            .shell {
              width: min(100% - 18px, 1080px);
              padding-top: 16px;
              padding-bottom: 28px;
            }

            .hero,
            .article-card {
              padding: 16px;
              border-radius: 22px;
            }

            .hero-title {
              font-size: 2rem;
            }

            .section-head {
              align-items: start;
              flex-direction: column;
            }

            .article-card {
              min-height: 0;
            }

            .article-main {
              width: 100%;
            }

            .article-cover {
              position: relative;
              top: auto;
              right: auto;
              bottom: auto;
              width: 100%;
              height: 180px;
              margin-top: 14px;
              pointer-events: auto;
            }

            .cover-box {
              border-radius: 18px;
            }

            .cover-sheen {
              background: linear-gradient(180deg, rgba(255,255,255,0.08), rgba(255,255,255,0.18));
            }
          }
        </style>
      </head>
      <body>
        <div class="shell">
          <header class="hero">
            <div class="hero-main">
              <div class="eyebrow">
                <span class="eyebrow-dot"></span>
                <span>Atom Feed</span>
              </div>

              <h1 class="hero-title"><xsl:value-of select="$title"/></h1>

              <p class="hero-subtitle">
                <xsl:choose>
                  <xsl:when test="string-length(normalize-space($subtitle)) &gt; 0">
                    <xsl:value-of select="$subtitle"/>
                  </xsl:when>
                  <xsl:otherwise>这里展示的是博客的 Atom 订阅源，保持简洁、精致与高可读性，让内容本身自然浮现。</xsl:otherwise>
                </xsl:choose>
              </p>

              <div class="hero-meta">
                <div class="meta-pill"><strong><xsl:value-of select="count(/atom:feed/atom:entry)"/></strong><span>篇文章</span></div>
                <div class="meta-pill"><strong><xsl:value-of select="substring($updated, 1, 10)"/></strong><span>最近更新</span></div>
                <div class="meta-pill"><strong>GB</strong><span>订阅源页面</span></div>
              </div>

              <div class="subscribe">
                <div class="subscribe-title">使用你喜欢的阅读器订阅</div>
                <div class="subscribe-desc">这是可被 RSS / Atom 阅读器直接识别的订阅源。当前页面只是为它附上一层轻盈的玻璃外观，让封面、标题与摘要以更优雅的方式呈现。</div>
                <div class="subscribe-links">
                  <a class="subscribe-link" href="https://feedly.com/i/subscription/feed/{$link}" target="_blank" rel="noopener noreferrer">Feedly</a>
                  <a class="subscribe-link" href="https://www.inoreader.com/feed/{$link}" target="_blank" rel="noopener noreferrer">Inoreader</a>
                  <a class="subscribe-link" href="https://www.newsblur.com/?url={$link}" target="_blank" rel="noopener noreferrer">NewsBlur</a>
                  <a class="subscribe-link" href="follow://add?url={$link}" rel="noopener noreferrer">Follow</a>
                  <a class="subscribe-link" href="feed:{$link}" rel="noopener noreferrer">RSS Reader</a>
                  <a class="subscribe-link" href="{$link}" target="_blank" rel="noopener noreferrer">访问博客</a>
                </div>
              </div>
            </div>
          </header>

          <div class="section-head">
            <div class="section-title">最新文章</div>
            <div class="section-note">文章封面取自 feed 中的 enclosure 图片</div>
          </div>

          <div class="article-list">
            <xsl:for-each select="/atom:feed/atom:entry">
              <xsl:variable name="articleLink">
                <xsl:choose>
                  <xsl:when test="atom:link[@rel='alternate'][1]/@href">
                    <xsl:value-of select="atom:link[@rel='alternate'][1]/@href"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="atom:link[1]/@href"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="cover">
                <xsl:choose>
                  <xsl:when test="atom:link[@rel='enclosure' and starts-with(@type, 'image/')][1]/@href">
                    <xsl:value-of select="atom:link[@rel='enclosure' and starts-with(@type, 'image/')][1]/@href"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="atom:link[@rel='enclosure'][1]/@href"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>

              <article>
                <xsl:attribute name="class">
                  <xsl:text>article-card</xsl:text>
                  <xsl:if test="position() &gt; 5">
                    <xsl:text> is-hidden</xsl:text>
                  </xsl:if>
                </xsl:attribute>
                <div class="article-main">
                  <div class="article-topline">
                    <xsl:if test="atom:category[1]/@term">
                      <a class="article-category" href="{atom:category[1]/@scheme}" target="_blank" rel="noopener noreferrer">
                        <xsl:value-of select="atom:category[1]/@term"/>
                      </a>
                    </xsl:if>
                    <span><xsl:value-of select="substring(atom:published, 1, 10)"/></span>
                    <span>·</span>
                    <span><xsl:value-of select="atom:author/atom:name"/></span>
                  </div>

                  <h2 class="article-title">
                    <a href="{$articleLink}" target="_blank" rel="noopener noreferrer">
                      <xsl:value-of select="atom:title"/>
                    </a>
                  </h2>

                  <p class="article-summary"><xsl:value-of select="atom:summary"/></p>

                  <xsl:if test="atom:category">
                    <div class="article-tags">
                      <xsl:for-each select="atom:category[position() &lt;= 6]">
                        <a class="article-chip" href="{@scheme}" target="_blank" rel="noopener noreferrer">
                          <xsl:value-of select="@term"/>
                        </a>
                      </xsl:for-each>
                    </div>
                  </xsl:if>
                </div>

                <div class="article-cover">
                  <a class="cover-box" href="{$articleLink}" target="_blank" rel="noopener noreferrer">
                    <xsl:choose>
                      <xsl:when test="string-length(normalize-space($cover)) &gt; 0">
                        <img class="cover-image" src="{$cover}" alt="{atom:title}"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <div class="cover-fallback"></div>
                      </xsl:otherwise>
                    </xsl:choose>
                    <div class="cover-sheen"></div>
                  </a>
                </div>
              </article>
            </xsl:for-each>
          </div>

          <xsl:if test="count(/atom:feed/atom:entry) &gt; 5">
            <div class="more-wrap" id="more-actions">
              <button class="more-button" id="show-more-posts" type="button">显示更多文章</button>
            </div>
          </xsl:if>

          <footer class="footer">
            <div class="footer-meta">
              <div>
                <xsl:choose>
                  <xsl:when test="string-length(normalize-space($rights)) &gt; 0">
                    <xsl:value-of select="$rights"/>
                  </xsl:when>
                  <xsl:otherwise>All rights reserved 2026, LixdHappy</xsl:otherwise>
                </xsl:choose>
              </div>
            </div>
            <div class="footer-links">
              <a class="footer-link" href="{$link}" target="_blank" rel="noopener noreferrer">博客主页</a>
              <a class="footer-link" href="https://github.com/willow-god/hexo-pretty-feed" target="_blank" rel="nofollow noopener noreferrer">Pretty Feed</a>
              <a class="footer-link" href="https://www.gbfun.cc/" target="_blank" rel="nofollow noopener noreferrer">LixdHappy</a>
            </div>
          </footer>

          <script>
            (function () {
              var trigger = document.getElementById('show-more-posts');
              var container = document.getElementById('more-actions');
              if (!trigger || !container) return;
              var blogUrl = '<xsl:value-of select="$link"/>';
              var hiddenItems = function () {
                return document.querySelectorAll('.article-card.is-hidden');
              };
              trigger.addEventListener('click', function () {
                var items = hiddenItems();
                var i = 0;
                var link;
                if (!items.length) return;
                while (true) {
                  if (!items[i]) break;
                  if (i == 5) break;
                  items[i].classList.remove('is-hidden');
                  i += 1;
                }
                if (!hiddenItems().length) {
                  container.removeChild(trigger);
                  link = document.createElement('a');
                  link.className = 'more-link';
                  link.href = blogUrl;
                  link.target = '_blank';
                  link.rel = 'noopener noreferrer';
                  link.appendChild(document.createTextNode('前往博客查看更多'));
                  container.appendChild(link);
                }
              });
            })();
          </script>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
