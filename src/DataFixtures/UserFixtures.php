<?php

namespace App\DataFixtures;

use App\Entity\User;
use App\Manager\UserManager;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class UserFixtures extends Fixture
{
    public function __construct(private readonly UserManager $manager)
    {
    }

    public function load(ObjectManager $manager): void
    {
        $user = new User();
        $user->setEmail('user@example.com');
        $user->setPlainPassword('passpass');

        $this->manager->save($user);
    }
}
