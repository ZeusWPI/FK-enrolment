<h2>Registreren via stamnummer</h2>
<div class="cols">
    <p class="col col-2">
    <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.180/w.110"
             alt="<?php echo $kring->kort; ?>" class="image-center" />
    </p>
    <div class="col col-4 col-last">

    <p>Vul onderstaand formulier in om je te registreren. Velden met een <em>*</em> zijn verplicht.</p>

    <?php echo form_open('/registratie/via_ugentnr'); ?>

    <dl class="form">
        <dt><?php echo form_label('Stamnummer<em>*</em>:', 'ugent_nr'); ?></dt>
        <dd>
            <?php echo form_input('ugent_nr', set_value('ugent_nr')); ?>
            <?php echo form_error('ugent_nr', '<div class="error">', '</div>'); ?>
        </dd>
        <dt><?php echo form_label('Voornaam<em>*</em>:', 'first_name'); ?></dt>
        <dd>
            <?php echo form_input('first_name', set_value('first_name')); ?>
            <?php echo form_error('first_name', '<div class="error">', '</div>'); ?>
        </dd>
        <dt><?php echo form_label('Familienaam<em>*</em>:', 'last_name'); ?></dt>
        <dd>
            <?php echo form_input('last_name', set_value('last_name')); ?>
            <?php echo form_error('last_name', '<div class="error">', '</div>'); ?>
        </dd>
    </dl>
    
    <dl class="form">
        <dt><?php echo form_label('E-mailadres:','email'); ?></dt>
        <dd>
            <?php echo form_input('email', set_value('email')); ?>
            <?php echo form_error('email', '<div class="error">', '</div>'); ?>
        </dd>
        <dt><?php echo form_label('GSM-nummer:', 'cellphone'); ?></dt>
        <dd>
            <?php echo form_input('cellphone', set_value('cellphone')); ?>
            <?php echo form_error('cellphone', '<div class="error">', '</div>'); ?>
        </dd>
        <dt><?php echo form_label('Kotadres:','address_kot'); ?></dt>
        <dd>
            <?php echo form_textarea(array('name' => 'address_kot',
                'rows' => 2, 'cols' => 20), set_value('address_kot')); ?>
            <?php echo form_error('address_kot', '<div class="error">', '</div>'); ?>
        </dd>
        <dt><?php echo form_label('Thuisadres:','address_home'); ?></dt>
        <dd>
            <?php echo form_textarea(array('name' => 'address_home',
            'rows' => 2, 'cols' => 20), set_value('address_home')); ?>
            <?php echo form_error('address_home', '<div class="error">', '</div>'); ?>
        </dd>
    </dl>
    
    <!-- @TODO: link naar privacy policy -->
    <p>Wat gebeurt er met mijn gegevens?</p>

    <p><?php echo form_submit('submit', 'Registreren!'); ?></p>
    
    <?php echo form_close(); ?>

    </div>
</div>
