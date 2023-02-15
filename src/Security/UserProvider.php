<?php

namespace App\Security;

use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\PropertyAccess\PropertyAccess;
use Symfony\Component\Security\Core\Exception\UnsupportedUserException;
use Symfony\Component\Security\Core\Exception\UserNotFoundException;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Component\Security\Core\User\UserProviderInterface;

class UserProvider implements UserProviderInterface
{
    public function __construct(private readonly EntityManagerInterface $manager)
    {
    }

    public function loadUserByIdentifier(string $identifier): UserInterface
    {
        $user = $this->manager->getRepository(User::class)->findOneBy(['email' => $identifier]);

        if (!$user) {
            throw new NotFoundHttpException();
        }

        return $user;
    }

    public function refreshUser(UserInterface $user): UserInterface
    {
        if (!$user instanceof User) {
            throw new UnsupportedUserException(sprintf('Invalid user class "%s".', get_class($user)));
        }

        return $this->findUser(['email' => $user->getEmail()]);
    }

    protected function findUser(array $criteria): ?User
    {
        return $this->manager->getRepository(User::class)->findOneBy($criteria);
    }

    public function supportsClass(string $class): bool
    {
        return User::class === $class || is_subclass_of($class, User::class);
    }
}
