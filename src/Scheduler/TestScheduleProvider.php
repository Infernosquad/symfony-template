<?php

namespace App\Scheduler;

use App\Message\SendHubMessage;
use Symfony\Component\Scheduler\Attribute\AsSchedule;
use Symfony\Component\Scheduler\RecurringMessage;
use Symfony\Component\Scheduler\Schedule;
use Symfony\Component\Scheduler\ScheduleProviderInterface;

#[AsSchedule]
class TestScheduleProvider implements ScheduleProviderInterface
{
    public function getSchedule(): Schedule
    {
        return $this->schedule ??= (new Schedule())
            ->with(RecurringMessage::every('10 seconds', new SendHubMessage()));
    }
}
