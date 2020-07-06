<?php

namespace AgiledropComposer;

use Composer\Installer\PackageEvent;
use Composer\Script\Event;
use Composer\Util\Filesystem;
use Symfony\Component\Finder\Finder;

class Installer {

    const WP_DIR_COPY = [
        'contrib/plugins' => 'wp-content/plugins',
        'custom/plugins' => 'wp-content/plugins',
        'contrib/mu-plugins' => 'wp-content/mu-plugins',
        'custom/mu-plugins' => 'wp-content/mu-plugins',
        'contrib/themes' => 'wp-content/themes',
        'custom/themes' => 'wp-content/themes',
    ];

    public static function postInstall(Event $event) {
        $wpPackages = $event->getComposer()->getRepositoryManager()->getLocalRepository()->findPackages('johnpbloch/wordpress');
        if (!$wpPackages) {
            $event->getIO()->writeError('johnpbloch/wordpress package is not installed! Aborting installation.');
            return null;
        }

        $packageExtra = $event->getComposer()->getPackage()->getExtra();
        if (empty($packageExtra['wordpress-install-dir'])) {
            $event->getIO()->writeError('Variable "wordpress-install-dir" is not defined in composer.json! Aborting installation.');
            return null;
        }
        $wpDir = $packageExtra['wordpress-install-dir'];

        $fs = new Filesystem();
        $rootDirectory = dirname($event->getComposer()->getConfig()->getConfigSource()->getName());

        self::emptyDirectory($fs, $rootDirectory . '/' . $wpDir . '/' . 'wp-content/plugins');
        self::emptyDirectory($fs, $rootDirectory . '/' . $wpDir . '/' . 'wp-content/mu-plugins');
        self::emptyDirectory($fs, $rootDirectory . '/' . $wpDir . '/' . 'wp-content/themes');

        foreach (self::WP_DIR_COPY as $source => $destination) {
            try {
                $fs->copy($rootDirectory . '/' . $source, $rootDirectory . '/' . $wpDir . '/' . $destination);
            } catch (\ErrorException $ex) {
                // Silently skip non-existing folders
            }
        }

        $fs->remove($rootDirectory . '/' . $wpDir . '/' . 'wp-content/themes/.gitkeep');
        $fs->remove($rootDirectory . '/' . $wpDir . '/' . 'wp-content/plugins/.gitkeep');
        $fs->remove($rootDirectory . '/' . $wpDir . '/' . 'wp-content/mu-plugins/.gitkeep');
    }

    private function handlePackage($rootDir, $package, $operation) {
    	$fs = new Filesystem();
    	$packageSplit = explode('/', $package);
		if ($packageSplit[0] === 'wpackagist-plugin') {
			$pluginDir = $rootDir . '/contrib/plugins/' . $packageSplit[1];
			$corePluginDir = $rootDir . '/wp/wp-content/plugins/' . $packageSplit[1];
			if ($operation === 'copy') {
				$fs->copy($pluginDir, $corePluginDir);
			}
			if ($operation === 'delete') {
				$fs->remove($corePluginDir);
			}
		}
		if ($packageSplit[0] === 'wpackagist-theme') {
			$themeDir = $rootDir . '/contrib/themes/' . $packageSplit[1];
			$coreThemeDir = $rootDir . '/wp/wp-content/themes/' . $packageSplit[1];
			if ($operation === 'copy') {
				$fs->copy($themeDir, $coreThemeDir);
			}
			if ($operation === 'delete') {
				$fs->remove($coreThemeDir);
			}
		}
    }

    public static function postPackageInstall(PackageEvent $event) {
    	$package = $event->getOperation()->getPackage()->getName();
	    $rootDirectory = dirname($event->getComposer()->getConfig()->getConfigSource()->getName());
	    self::handlePackage($rootDirectory, $package, 'copy');
    }

    public static function postPackageUninstall(PackageEvent $event) {
	    $package = $event->getOperation()->getPackage()->getName();
	    $rootDirectory = dirname($event->getComposer()->getConfig()->getConfigSource()->getName());
	    self::handlePackage($rootDirectory, $package, 'delete');
    }

    protected static function emptyDirectory(Filesystem $fs, $dir, $ensureDirectoryExists = true)
    {
        if (file_exists($dir) && is_link($dir)) {
            $fs->unlink($dir);
        }

        if ($ensureDirectoryExists) {
            $fs->ensureDirectoryExists($dir);
        }

        if (is_dir($dir)) {
            $finder = Finder::create()
                ->ignoreVCS(false)
                ->ignoreDotFiles(false)
                ->notPath('index.php')
                ->depth(0)
                ->in($dir);

            foreach ($finder as $path) {
                $fs->remove((string) $path);
            }
        }
    }
}