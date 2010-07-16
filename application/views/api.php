<html>
<head>
<title>Welcome to FK-enrolment Server</title>

<style type="text/css">

body {
 background-color: #fff;
 margin: 40px;
 font-family: Lucida Grande, Verdana, Sans-serif;
 font-size: 14px;
 color: #4F5155;
}

a {
 color: #003399;
 background-color: transparent;
 font-weight: normal;
}

h1 {
 color: #444;
 background-color: transparent;
 border-bottom: 1px solid #D0D0D0;
 font-size: 16px;
 font-weight: bold;
 margin: 24px 0 2px 0;
 padding: 5px 0 6px 0;
}

code {
 font-family: Monaco, Verdana, Sans-serif;
 font-size: 12px;
 background-color: #f9f9f9;
 border: 1px solid #D0D0D0;
 color: #002166;
 display: block;
 margin: 14px 0 14px 0;
 padding: 12px 10px 12px 10px;
}

</style>
</head>
<body>

<h1>Welcome to the FK-enrolment Server!</h1>

<p>Below is the documentation for the API. Each method requires the use of your API key which can be found on the FK intranet.</p>

<p>To make sure your application is compatible with future changes, always use a version parameter in the URL, for example
    <code><?php echo site_url('api/v1/add_member'); ?></code>
</p>

<h2>add_member</h2>

<dl>
    <dt>Type</dt>
    <dd>POST</dd>
    <dt>Parameters</dt>
    <dd><ul>
        <li>kring_id <i>(integer, required)</i></li>
        <li>first_name <i>(string, required)</i></li>
        <li>last_name <i>(string, required)</i></li>
        <li>email <i>(string, optional if ugent_nr is provided)</i></li>
        <li>ugent_nr <i>(string, optional if email is provided)</i></li>
        <li>ugent_login <i>(string, optional)</i></li>
        <li>cellphone <i>(string, optional)</i></li>
        <li>address_home <i>(string, optional)</i></li>
        <li>address_kot <i>(string, optional)</i></li>
     </ul></dd>
</dl>

</body>
</html>
