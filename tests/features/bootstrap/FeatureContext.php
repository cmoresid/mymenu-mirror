<?php


class FeatureContext extends Behat\MinkExtension\Context\MinkContext
{
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
			$driver = $this->getSession()->getDriver();
	        $textFields = $driver->find("//window");
			
			echo count($textFields), "\n";
			
			if (count($textFields) > 0) {
				$textField->click();
			}
	    }

	    /**
	     * @Then /^The keyboard should appear$/
	     */
	    public function theKeyboardShouldAppear()
	    {
		
	    }
}

