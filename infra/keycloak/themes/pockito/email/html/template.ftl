<#macro emailLayout>
<!doctype html>
<html lang="${locale.language}" dir="${(ltr)?then('ltr','rtl')}">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Pockito</title>
  </head>
  <body style="margin:0;padding:0;background:#f7f9fd;color:#071625;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Hiragino Sans','Noto Sans JP',Arial,sans-serif;">
    <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="width:100%;background:#f7f9fd;">
      <tr>
        <td align="center" style="padding:32px 16px;">
          <table role="presentation" width="600" cellspacing="0" cellpadding="0" border="0" style="width:100%;max-width:600px;">
            <tr>
              <td style="padding:0 8px 20px;">
                <img src="${url.resourcesUrl}/img/pockito-logo.png" width="176" alt="Pockito" style="display:block;width:176px;max-width:52%;height:auto;border:0;">
              </td>
            </tr>
            <tr>
              <td style="padding:32px;border:1px solid #dde7f0;border-radius:16px;background:#ffffff;box-shadow:0 8px 24px rgba(7,22,37,.06);font-size:16px;line-height:1.6;">
                <#nested>
              </td>
            </tr>
            <tr>
              <td style="padding:20px 12px 0;color:#4d657d;font-size:12px;line-height:1.6;text-align:center;">
                ${msg("pkEmailSecurityFooter")}
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>
</html>
</#macro>
