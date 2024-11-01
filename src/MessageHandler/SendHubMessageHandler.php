<?php

namespace App\MessageHandler;

use App\Message\SendHubMessage;
use Symfony\Component\Mercure\HubInterface;
use Symfony\Component\Mercure\Update;
use Symfony\Component\Messenger\Attribute\AsMessageHandler;
use Twig\Environment;

#[AsMessageHandler]
final class SendHubMessageHandler
{
    public function __construct(private readonly HubInterface $hub, private readonly Environment $twig)
    {
    }

    public function __invoke(SendHubMessage $message): void
    {
        $this->hub->publish(new Update('chat', $this->twig->render('stream.html.twig')));
    }
}
