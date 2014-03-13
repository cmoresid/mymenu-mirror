<?php

use Behat\Behat\Context\BehatContext;

use Behat\Mink\Mink,
    Behat\Mink\Session,
    Behat\Mink\Driver\Selenium2Driver;

use Selenium\Client as SeleniumClient;

class GuiContext extends BehatContext
{

    public function __construct(array $parameters)
    {
        $mink = new Mink(array(
            'selenium2' => new Session(new Selenium2Driver($parameters['wd_capabilities']['browser'], $parameters['wd_capabilities'], $parameters['wd_host'])),
        ));

        $this->gui = $mink->getSession('selenium2');
    }

	/**
     * @Given /^I am on the login screen$/
     */
    public function iAmOnTheLoginScreen()
    {
    }

    /**
     * @When /^I click on "([^"]*)"$/
     */
    public function iClickOn($arg1)
    {
		// We need to get access to the underlying
		// driver in order to interact with the simulator.
		$driver = $this->gui->getDriver();
		
		// Need to start the driver
		$driver->start();
		
		// Open up the Appium application in order to
		// and click the "i" button in order to navigate
		// the various controls available.
		$driver->click("//window[1]/scrollview[1]/textfield[1]");
		
		// Then we need to stop the driver
		// for every method call
		$driver->stop();
    }

    /**
     * @Then /^The keyboard should appear$/
     */
    public function theKeyboardShouldAppear()
    {
		$driver = $this->gui->getDriver();
		
		// Need to start the driver
		$driver->start();
    }
}
