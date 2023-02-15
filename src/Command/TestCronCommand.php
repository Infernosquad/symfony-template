<?php

namespace App\Command;

use App\Message\SendHubMessage;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Mercure\HubInterface;
use Symfony\Component\Messenger\MessageBusInterface;
use Twig\Environment;

#[AsCommand(
    name: 'app:test-cron',
    description: 'Add a short description for your command',
)]
class TestCronCommand extends Command
{
    public function __construct(private readonly MessageBusInterface $bus, private readonly HubInterface $hub, private readonly Environment $twig)
    {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $this->bus->dispatch(new SendHubMessage());

        return Command::SUCCESS;
    }
}
