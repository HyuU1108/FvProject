package polymorphism;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

@Component("tv")
public class LgTV implements TV{

	@Autowired
	//@Qualifier("apple")
	//@Resource(name = "sony")
	private Speaker speaker;
	
	public LgTV() {
	      System.out.println("====> LgTV 객체 생성 ....");
	}
	
	@Override
	public void powerOn() {
		// TODO Auto-generated method stub
		System.out.println("Lg TV ------- 전원 끈다. ");
	}

	@Override
	public void powerOff() {
		// TODO Auto-generated method stub
		System.out.println("Lg TV ------- 전원 끈다. ");
	}

	@Override
	public void volumeUp() {
		// TODO Auto-generated method stub
		//System.out.println("Lg TV ----- 소리 올린다. ");
		speaker.volumeUp();
	}

	@Override
	public void volumeDown() {
		// TODO Auto-generated method stub
		System.out.println("Lg TV ----- 소리 내린다. ");
		speaker.volumeDown();
	}
	
}
