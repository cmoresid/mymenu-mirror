/*
 * Copyright (C) 2014 MyMenu, Inc.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see [http://www.gnu.org/licenses/].
 */

package ca.mymenuapp.data;

import android.content.res.AssetManager;
import android.net.Uri;
import android.os.SystemClock;
import android.util.LruCache;
import com.squareup.picasso.Downloader;
import java.io.IOException;
import retrofit.MockRestAdapter;

/**
 * A Picasso {@link Downloader} which loads images from assets but attempts to emulate the
 * subtleties of a real HTTP client and its disk cache.
 * <p>
 * Images <em>must</em> be in the form {@code mock:///path/to/asset.png}.
 */
public final class MockDownloader implements Downloader {
  private final MockRestAdapter mockRestAdapter;
  private final AssetManager assetManager;

  /** Emulate the disk cache by storing the URLs in an LRU using its size as the value. */
  private final LruCache<String, Long> emulatedDiskCache =
      new LruCache<String, Long>(DataModule.DISK_CACHE_SIZE) {
        @Override protected int sizeOf(String key, Long value) {
          return (int) Math.min(value.longValue(), Integer.MAX_VALUE);
        }
      };

  public MockDownloader(MockRestAdapter mockRestAdapter, AssetManager assetManager) {
    this.mockRestAdapter = mockRestAdapter;
    this.assetManager = assetManager;
  }

  @Override public Response load(Uri uri, boolean localCacheOnly) throws IOException {
    if (!"mock".equals(uri.getScheme())) {
      throw new RuntimeException("Attempted to download non-mock image ("
          + uri
          + ") using the mock downloader. Mock URLs must use scheme 'mock'.");
    }

    String imagePath = uri.getPath().substring(1); // Grab only the path sans leading slash.

    // Check the disk cache for the image. A non-null return value indicates a hit.
    boolean cacheHit = emulatedDiskCache.get(imagePath) != null;

    // If there's a hit, grab the image stream and return it.
    if (cacheHit) {
      return new Response(assetManager.open(imagePath), true);
    }

    // If we are not allowed to hit the network and the cache missed return a big fat nothing.
    if (localCacheOnly) {
      return null;
    }

    // If we got this far there was a cache miss and hitting the network is required. See if we need
    // to fake an network error.
    if (mockRestAdapter.calculateIsFailure()) {
      SystemClock.sleep(mockRestAdapter.calculateDelayForError());
      throw new IOException("Fake network error!");
    }

    // We aren't throwing a network error so fake a round trip delay.
    SystemClock.sleep(mockRestAdapter.calculateDelayForCall());

    // Since we cache missed, load the file size and put it in the LRU.
    long size = assetManager.openFd(imagePath).getLength();
    emulatedDiskCache.put(imagePath, size);

    // Grab the image stream and return it.
    return new Response(assetManager.open(imagePath), false);
  }
}
