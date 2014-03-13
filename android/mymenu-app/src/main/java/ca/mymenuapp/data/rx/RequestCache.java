package ca.mymenuapp.data.rx;

import com.f2prateek.ln.Ln;
import rx.Observer;
import rx.Subscription;
import rx.subjects.PublishSubject;

/**
 * A class to keep track of requests and their response.
 */
public class RequestCache<T> {
  private PublishSubject<T> request;
  private T data;

  public static <T> RequestCache<T> create() {
    return new RequestCache<T>();
  }

  private RequestCache() {
    request = null;
    data = null;
  }

  /**
   * Check if a response is cached.
   * If it is, notify the observer.
   */
  public void cacheCheck(Observer<T> observer) {
    if (data != null) {
      // We have a cached value. Emit it immediately.
      Ln.d("cached");
      observer.onNext(data);
    }
  }

  /**
   * Check if a request is in progress. If it is, join it and return true.
   */
  public Subscription requestCheck(Observer<T> observer) {
    if (request != null) {
      // There's an in-flight network request for this section already. Join it.
      Ln.d("join");
      return request.subscribe(observer);
    }
    return null;
  }

  /**
   * Setup this cache for a request.
   */
  public PublishSubject<T> startRequest(Observer<T> observer) {
    Ln.d("fire");
    request = PublishSubject.create();

    Subscription subscription = request.subscribe(observer);

    request.subscribe(new EndObserver<T>() {
      @Override public void onEnd() {
        request = null;
      }

      @Override public void onNext(T response) {
        data = response;
      }
    });
    return request;
  }
}
