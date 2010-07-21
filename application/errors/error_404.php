<?php
header("HTTP/1.1 404 Not Found");

ob_start();
?>
		<h3><?php echo $heading; ?></h3>
		<p><?php echo $message; ?></p>
<?php
$contents = ob_get_clean();

$ci = get_instance();
$ci->load->view('layout', array(
    'pageTitle' => $heading,
    'contents' => $contents
));