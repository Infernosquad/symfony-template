<?php

namespace App\MessageHandler;

use App\Message\SendHubMessage;
use Symfony\Component\Mercure\HubInterface;
use Symfony\Component\Mercure\Update;
use Symfony\Component\Messenger\Handler\MessageHandlerInterface;
use Twig\Environment;

final class SendHubMessageHandler implements MessageHandlerInterface
{
    public function __construct(private readonly HubInterface $hub, private readonly Environment $twig)
    {
    }

    public function __invoke(SendHubMessage $message)
    {
        $this->hub->publish(new Update('chat', $this->twig->render('stream.html.twig')));
    }
}
