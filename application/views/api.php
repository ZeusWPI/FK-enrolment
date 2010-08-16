<h2>Welcome to the FK-enrolment Server!</h2>

<p>Below is the documentation for the API. Each method requires the use of your API key which can be found on the FK intranet.</p>

<p>To make sure your application is compatible with future changes, always use a version parameter in the URL, for example
<code><?php echo site_url('api/v1/add_member'); ?></code></p>

<p>All methods require the presence of an API-key, which will associate your request with your club. This key should be
provided as a URL parameter, whatever the request type may be. An example URL is
<code><?php echo site_url('api/v1/add_member<b>?key=abcdefgh1234,</b>'); ?></code></p>

<p>The API is compatible with many common data-exchange formats such as xml, json, csv or php. To
    use a particular format, just append it to the end of the URL.
    Example: <code><?php echo site_url('api/v1/associate_card<b>.json</b>?key=abcdefgh1234,'); ?></code>

<p>All requests

<h3>add_member</h3>

<p>Register a new member and him to the FK database. The return value <code>member_id</code> should
be stored by the receiver and used later in the card association.</p>

<dl>
    <dt>Type</dt>
    <dd>POST</dd>
    <dt>Parameters</dt>
    <dd><ul>
        <li>first_name <i>(string, required)</i></li>
        <li>last_name <i>(string, required)</i></li>
        <li>email <i>(string, optional if ugent_nr is provided)</i></li>
        <li>ugent_nr <i>(string, optional if email is provided)</i></li>
        <li>ugent_login <i>(string, optional)</i></li>
        <li>cellphone <i>(string, optional)</i></li>
        <li>address_home <i>(string, optional)</i></li>
        <li>address_kot <i>(string, optional)</i></li>
     </ul></dd>
     <dt>Returns</dt>
     <dd><ul>
        <li>barcode <i>(string)</i></li>
     </ul></dd>
</dl>

<h3>associate_card</h3>

<p>Associate a member with a card number. This is the second step after registration
    and completes the process. This call should probably occur simultaneously with
    the distribution of the card.</p>

<p><em>Warning</em>: this call can only be executed once per academic year
    for each member.</p>

<dl>
    <dt>Type</dt>
    <dd>POST</dd>
    <dt>Parameters</dt>
    <dd><ul>
        <li>member_id <i>(integer, required)</i></li>
        <li>card_id <i>(integer, required)</i></li>
     </ul></dd>
</dl>

<h3>barcode</h3>

<p>Generates an <a href="http://en.wikipedia.org/wiki/EAN13">EAN13</a> barcode.
    This method <b>does not</b> require an API key so it's safe to use in your
    webpages.</p>
<p>This method will return a PNG image, so any format specifier is ignored.</p>

<dl>
    <dt>Type</dt>
    <dd>GET</dd>
    <dt>Parameters</dt>
    <dd><ul>
        <li>member_id <i>(integer, required)</i></li>
     </ul></dd>
</dl>
