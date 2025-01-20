package polymorphism;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;

public class TVUser {

	public static void main(String[] args) {
		/*
		SamsungTV tv = new SamsungTV();
		tv.powerOn();
		tv.volumeUp();
		tv.volumeDown();
		tv.powerOff();
		*/
		
		/*
		LgTV tv = new LgTV();
		tv.turnOn();
		tv.soundUp();
		tv.soundDown();
		tv.turnOff();
		*/
		//TV tv = new SamsungTV();
		
		/*
		BeanFactory factory = new BeanFactory();
		TV tv = (TV)factory.getBean("samsung");
		//TV tv = new LgTV();
		tv.powerOn();
		tv.volumeUp();
		tv.volumeDown();
		tv.powerOff();
		*/
		
		// 1. Spring 컨테이너 구동한다.
	
		AbstractApplicationContext factory =
				new GenericXmlApplicationContext(
						"applicationContext.xml");
	
		/*  스프링 컨테이너 종류
		 *  GenericXmlApplicationContext
		 *   - 파일 시스템이나 클래스 경로(src/main/resources)에 있는
		 *     XML 설정 파일을 로딩하여 구동하는 컨테이너이다.
		 *  
		 *  XmlWebApplicationContext
		 *   - 웹 기반의 스프링 애플리케이션을 개발할때 사용하는 컨테이너이다.
		 */
		
		
		// 2. Spring 컨테이너로부터 필요한 객체를 요청(Lookup)한다.
		TV tv = (TV)factory.getBean("tv");//LgTV
		/*
		TV tv1 = (TV)factory.getBean("tv");//LgTV
		TV tv2 = (TV)factory.getBean("tv");//LgTV
		TV tv3 = (TV)factory.getBean("tv");//LgTV
		*/
		tv.powerOn();
		tv.volumeUp();
		tv.volumeDown();
		tv.powerOff();
		
		// 3. Spring 컨테이너를 종료 한다.
		factory.close();
		
		/*
		TV tv1 = new SamsungTV(); // 메모리의 낭비를 가져올 수 있음
		TV tv2 = new SamsungTV();
		TV tv3 = new SamsungTV();
		
		TV tv2 = tv1; // 메모리 활용을 효율적으로
		TV tv3 = tv2;
		*/
		
		
	
	}

}
