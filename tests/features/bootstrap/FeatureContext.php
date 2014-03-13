<?php


class FeatureContext extends Behat\MinkExtension\Context\MinkContext
{
	public function __construct(array $parameters)
    {
		$this->useContext('gui',
		    new GuiContext($parameters)
		);
	}
}

