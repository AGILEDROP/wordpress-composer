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

    private function handlePackage($rootDir, $wpDir, $package, $operation) {
    	$fs = new Filesystem();
    	$packageSplit = explode('/', $package);
		if ($packageSplit[0] === 'wpackagist-plugin') {
			$pluginDir = $rootDir . '/contrib/plugins/' . $packageSplit[1];
			$corePluginDir = $rootDir . '/' . $wpDir . '/wp-content/plugins/' . $packageSplit[1];
			if ($operation === 'copy') {
				$fs->copy($pluginDir, $corePluginDir);
			}
			if ($operation === 'delete') {
				$fs->remove($corePluginDir);
			}
		}
		if ($packageSplit[0] === 'wpackagist-theme') {
			$themeDir = $rootDir . '/contrib/themes/' . $packageSplit[1];
			$coreThemeDir = $rootDir . '/' . $wpDir . '/wp-content/themes/' . $packageSplit[1];
			if ($operation === 'copy') {
				$fs->copy($themeDir, $coreThemeDir);
			}
			if ($operation === 'delete') {
				$fs->remove($coreThemeDir);
			}
		}
    }

    public static function postPackageInstall(PackageEvent $event) {
        $packageExtra = $event->getComposer()->getPackage()->getExtra();
        if (empty($packageExtra['wordpress-install-dir'])) {
            $event->getIO()->writeError('Variable "wordpress-install-dir" is not defined in composer.json! Aborting installation.');
            return null;
        }
        $wpDir = $packageExtra['wordpress-install-dir'];

    	$package = $event->getOperation()->getPackage()->getName();
	    $rootDirectory = dirname($event->getComposer()->getConfig()->getConfigSource()->getName());
	    (new Installer)->handlePackage($rootDirectory, $wpDir, $package, 'copy');
    }

    public static function postPackageUninstall(PackageEvent $event) {
        $packageExtra = $event->getComposer()->getPackage()->getExtra();
        if (empty($packageExtra['wordpress-install-dir'])) {
            $event->getIO()->writeError('Variable "wordpress-install-dir" is not defined in composer.json! Aborting installation.');
            return null;
        }
        $wpDir = $packageExtra['wordpress-install-dir'];

	    $package = $event->getOperation()->getPackage()->getName();
	    $rootDirectory = dirname($event->getComposer()->getConfig()->getConfigSource()->getName());
	    (new Installer)->handlePackage($rootDirectory, $wpDir, $package, 'delete');
    }

    private function getDirectories($directory) {
    	$directories = [];
	    if ($handle = opendir($directory)) {
		    while (false !== ($entry = readdir($handle))) {
			    $directories[] = $entry;
		    }
		    closedir($handle);
	    }
	    return array_diff($directories, ['.', '..', '.gitkeep']);
    }

    private function copyDirectories($fs, $directories, $fromPath, $toPath) {
	    foreach ($directories as $directory) {
		    $fs->copy($fromPath . '/' . $directory , $toPath . '/' . $directory);
	    }
    }

    public static function postUpdate(Event $event) {
        $packageExtra = $event->getComposer()->getPackage()->getExtra();
        if (empty($packageExtra['wordpress-install-dir'])) {
            $event->getIO()->writeError('Variable "wordpress-install-dir" is not defined in composer.json! Aborting installation.');
            return null;
        }
        $wpDir = $packageExtra['wordpress-install-dir'];
	    $rootDirectory = dirname($event->getComposer()->getConfig()->getConfigSource()->getName());

	    $pluginDir = $rootDirectory . '/contrib/plugins';
	    $customPluginDir = $rootDirectory . '/custom/plugins';
	    $themeDir = $rootDirectory . '/contrib/themes';
	    $customThemeDir = $rootDirectory . '/custom/themes';
	    $pluginCoreDir = $rootDirectory . '/' . $wpDir . '/wp-content/plugins/';
	    $themeCoreDir = $rootDirectory . '/' . $wpDir . '/wp-content/themes/';

	    $installer = new Installer();
	    $plugins = $installer->getDirectories($pluginDir);
	    $themes = $installer->getDirectories($themeDir);
	    $customPlugins = $installer->getDirectories($customPluginDir);
	    $customThemes = $installer->getDirectories($customThemeDir);

	    $fs = new Filesystem();
		$fs->remove($pluginCoreDir);
		$fs->remove($themeCoreDir);
	    $installer->copyDirectories($fs, $plugins, $pluginDir, $pluginCoreDir);
	    $installer->copyDirectories($fs, $themes, $themeDir, $themeCoreDir);
	    $installer->copyDirectories($fs, $customPlugins, $customPluginDir, $pluginCoreDir);
	    $installer->copyDirectories($fs, $customThemes, $customThemeDir, $themeCoreDir);
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