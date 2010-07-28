<?php
function my_range($low, $high, $step = 1) {
    $range = range($low, $high, $step);
    return array_combine($range, $range);
}
function month_to_human($i) {
    setlocale(LC_ALL, 'nl_NL.UTF-8');
    return strftime("%b", mktime(0, 0, 0, $i, 1, 2000));
}

$is_cas = ($method == 'CAS');
$disabled = $is_cas ? ' disabled="disabled"' : '';

if(!$is_cas) {
    $cas = array('ugentStudentID' => '', 'givenname' => '', 'surname' => '', 'mail' => '');
}
?>
<div class="cols">
    <p class="col col-2">
    <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.180/w.120"
             alt="<?php echo $kring->kort; ?>" class="image-center image-header-offset" />
    </p>
    <div class="col col-5 col-last">
    <h2>Inschrijven <?php echo $is_cas ? "via CAS" : "met stamnummer"; ?></h2>

    <p>Vul onderstaand formulier in om je te registreren. Velden met een <em>*</em> zijn verplicht.</p>

    <?php echo form_open(uri_string()); ?>

    <dl class="form">
        <dt><?php echo form_label('Stamnummer<em>*</em>:', 'ugent_nr'); ?></dt>
        <dd>
            <?php echo form_input('ugent_nr', set_value('ugent_nr'), $disabled); ?>
            <?php echo form_error('ugent_nr'); ?>
        </dd>
        <dt><?php echo form_label('Voornaam<em>*</em>:', 'first_name'); ?></dt>
        <dd>
            <?php echo form_input('first_name', set_value('first_name'), $disabled); ?>
            <?php echo form_error('first_name'); ?>
        </dd>
        <dt><?php echo form_label('Familienaam<em>*</em>:', 'last_name'); ?></dt>
        <dd>
            <?php echo form_input('last_name', set_value('first_name'), $disabled); ?>
            <?php echo form_error('last_name'); ?>
        </dd>
        <dt><?php echo form_label('E-mailadres:', 'email'); ?></dt>
        <dd>
            <?php echo form_input('email', set_value('first_name'), $disabled); ?>
            <?php echo form_error('email'); ?>
        </dd>
    </dl>

    <dl class="form">
        <dt><label>Geslacht: </label></dt>
        <dd>
            <?php echo form_radio(array('name' => 'sex', 'id' => 'sex_m'),
                    'm', set_value('sex') == 'm'), ' ', form_label('Man', 'sex_m'); ?>
            <?php echo form_radio(array('name' => 'sex', 'id' => 'sex_f'),
                    'f', set_value('sex') == 'f'), ' ', form_label('Vrouw', 'sex_f'); ?>
            <?php echo form_error('sex'); ?>
        </dd>
        <dt><label>Geboortedatum: </label></dt>
        <dd>
            <?php echo form_dropdown('day_of_birth', my_range(01, 31), set_value('day_of_birth')); ?>
            <?php echo form_dropdown('month_of_birth', array_map('month_to_human', my_range(01, 12)), set_value('month_of_birth')); ?>
            <?php echo form_dropdown('year_of_birth', my_range(1900, 2010), set_value('year_of_birth', date('Y') - 18)); ?>
        </dd>
        <dt><?php echo form_label('GSM-nummer:', 'cellphone'); ?></dt>
        <dd>
            <?php echo form_input('cellphone', set_value('cellphone')); ?>
            <?php echo form_error('cellphone'); ?>
        </dd>
        <dt><?php echo form_label('Kotadres:','address_kot'); ?></dt>
        <dd>
            <?php echo form_textarea(array('name' => 'address_kot',
                'rows' => 2, 'cols' => 20), set_value('address_kot')); ?>
            <?php echo form_error('address_kot'); ?>
        </dd>
        <dt><?php echo form_label('Thuisadres:','address_home'); ?></dt>
        <dd>
            <?php echo form_textarea(array('name' => 'address_home',
            'rows' => 2, 'cols' => 20), set_value('address_home')); ?>
            <?php echo form_error('address_home'); ?>
        </dd>
    </dl>

    <!-- @TODO: link naar privacy policy -->
    <p>Wat gebeurt er met mijn gegevens?</p>

    <p><?php echo form_submit('submit', 'Registreren!'); ?></p>

    <?php echo form_close(); ?>

    </div>
</div>
