<?php

namespace App\MessageHandler;

use App\Message\SendHubMessage;
use Symfony\Component\Mercure\HubInterface;
use Symfony\Component\Mercure\Update;
use Symfony\Component\Messenger\Handler\MessageHandlerInterface;

final class SendHubMessageHandler implements MessageHandlerInterface
{
    public function __construct(private readonly HubInterface $hub)
    {
    }

    public function __invoke(SendHubMessage $message)
    {
        $this->hub->publish(new Update('chat', uniqid()));
    }
}
