<?php
ob_start();
?>
		<h3><?php echo $heading; ?></h3>
		<p><?php echo $message; ?></p>
<?php
$contents = ob_get_clean();

$ci = get_instance();
$ci->load->view('layout_error', array(
    'pageTitle' => $heading,
    'contents' => $contents
));