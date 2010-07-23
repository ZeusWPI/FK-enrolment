<?php header("HTTP/1.1 404 Not Found"); ?>
<?php global $CFG; ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="language" content="nl">
    <meta name="author" content="FK Gent" />
    <title><?php echo $heading; ?> &ndash; FaculteitenKonvent Gent</title>
    <link rel="stylesheet" type="text/css" href="<?php echo $CFG->item('base_url'); ?>assets/style.css">
</head>
<body>
    <div id="header-wrapper"><div id="header">
        <h1><a href="<?php echo $CFG->item('base_url'); ?>">FaculteitenKonvent Gent</a></h1>
    </div></div>

    <div id="main-wrapper"><div id="main" class="cols">
        <div class="col col-6">
            <h3><?php echo $heading; ?></h3>
            <p><?php echo $message; ?></p>
        </div>
    </div></div>

    <div id="footer">
        <p><a href="http://fkgent.be">FaculteitenKonvent Gent</a> &bull;
            De Therminal, Hoveniersberg 24 - 9000 Gent, Belgium &bull;
            +32.9.264.70.93 &bull; info@fkserv.ugent.be</p>
        <p><a href="http://github.com/zeuswpi/fk-enrolment">FK-enrolment</a>
            werd ontwikkeld door <a href="http://zeus.ugent.be">Zeus WPI</a>,
            de werkgroep informatica.</p>
    </div>
</body>
</html>
