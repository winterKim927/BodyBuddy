package com.edu.bodybuddy.model.myrecord;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.edu.bodybuddy.domain.myrecord.ExrDetailRecord;
import com.edu.bodybuddy.domain.myrecord.ExrRecord;
import com.edu.bodybuddy.exception.ExrRecordException;

@Service
public class ExrRecordServiceImpl implements ExrRecordService{
	private Logger logger=LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private ExrRecordDAO exrRecordDAO;
	
	@Autowired
	private ExrDetailRecordDAO exrDetailRecordDAO;
	
	
	@Override
	public List seletForMonth(Map<String, String> oneMonthPeriod) throws ExrRecordException{
		List<ExrRecord> exrRecordListMonth=exrRecordDAO.seletForMonth(oneMonthPeriod);
		return exrRecordListMonth;
	}
	
	 //exrRecordList로 가져오는 이유는 한 날짜에 운동을 여러가지 하기 때문에, 아예 List형식으로 받아가지고 와서, 안에서 반복문 돌려주기 위함이기도 하고
	@Transactional(propagation = Propagation.REQUIRED) //controller는 일을 시키기만 해야하기 때문에
	public void regist(List<ExrRecord> exrRecordList) throws ExrRecordException{
		//운동기록 insert
		for(int a=0; a<exrRecordList.size(); a++) {
			ExrRecord exrRecord=exrRecordList.get(a);
			logger.info("exrRecord에 담겨있는 내용은 :"+exrRecord);
			exrRecordDAO.insert(exrRecord);//실행 완료하면 idx값이 들어있음
			logger.info("등록된 member_idx 값은"+exrRecord.getMember_idx());
			logger.info("등록후 받아온 exr_record_idx값은 :"+ exrRecord.getExr_record_idx());
			logger.info("운동기록에 들어있는 상세운동의 갯수는 :"+exrRecord.getExrRecordDetailList().size());
			
			//운동기록 insert성공시, idx가져오고,  운동기록상세 데이터insert
			for(int i=0; i<exrRecord.getExrRecordDetailList().size(); i++) {
				ExrDetailRecord exrDetailRecord =exrRecord.getExrRecordDetailList().get(i);
				exrDetailRecord.setExr_record_idx(exrRecord.getExr_record_idx()); //이걸 이렇게 따로 set하고 넣어주는게 맞나?
				exrDetailRecord.setSet_number(i+1); //세트수 넣어주는 곳...
				logger.info("상세기록에 들어있는 kg 값은 : "+exrDetailRecord.getKg());
				logger.info("상세기록에 들어있는 times 값은 : "+exrDetailRecord.getTimes());
				exrDetailRecordDAO.insert(exrDetailRecord);
			}
		}
	}

	@Override
	public void delete(ExrRecord exrRecord) {
		
	}

	@Override
	public List<ExrRecord> selectForDay(String regdate) throws ExrRecordException{
		List<ExrRecord> exrList=exrRecordDAO.selectForDay(regdate);
		return exrList;
	}

}
