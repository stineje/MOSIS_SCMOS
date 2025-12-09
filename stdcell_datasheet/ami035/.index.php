<?php

require_once('../../../vlsi.config.php');

$Smarty->assign('Modules', array('projects/scells/SoC.module.tpl'));
$Smarty->assign('Content', 'projects/scells/ami035.content.tpl');
$Smarty->display('Template.tpl');

?>