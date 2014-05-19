<?php
// To run this test, install Sausage (see http://github.com/jlipps/sausage-bun
// to get the curl one-liner to run in this directory), then run:
//     vendor/bin/phpunit SimpleTest.php

require_once "vendor/autoload.php";
define("APP_PATH", realpath(dirname(__FILE__).'/../../apps/TestApp/build/Release-iphonesimulator/TestApp.app'));
if (!APP_PATH) {
    die("App did not exist!");
}

// require_once('PHPUnit/Extensions/AppiumTestCase.php');


class SimpleTest extends PHPUnit_Extensions_AppiumTestCase
{
    protected $numValues = array();

    public static $browsers = array(
        array(
            'local' => true,
            'port' => 4723,
            'browserName' => '',
            'desiredCapabilities' => array(
                'platformName' => 'iOS',
                'platformVersion' => '7.0',
                'deviceName' => 'iPhone Simulator',
                'name' => 'Appium iOS Test, PHP',
                'app' => APP_PATH
            )
        )
    );

    public function elemsByClassName($klass)
    {
        return $this->elements($this->using('class name')->value($klass));
    }

    protected function populate()
    {
        $elems = $this->elemsByClassName('UIATextField');
        foreach ($elems as $elem) {
            $randNum = rand(0, 10);
            $elem->value($randNum);
            $this->numValues[] = $randNum;
        }
    }

    public function testUiComputation()
    {
        $this->populate();
        $buttons = $this->elemsByClassName('UIAButton');
        $buttons[0]->click();
        $texts = $this->elemsByClassName('UIAStaticText');
        $this->assertEquals(array_sum($this->numValues), (int)($texts[0]->text()));
    }
}
