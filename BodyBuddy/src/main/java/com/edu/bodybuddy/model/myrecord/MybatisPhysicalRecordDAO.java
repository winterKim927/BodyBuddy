package com.edu.bodybuddy.model.myrecord;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.edu.bodybuddy.domain.myrecord.PhysicalRecord;
import com.edu.bodybuddy.exception.PhysicalRecordException;

@Repository
public class MybatisPhysicalRecordDAO implements PhysicalRecordDAO {
	
	Logger logger=LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public void insert(PhysicalRecord physicalRecord) throws PhysicalRecordException{
		int result=sqlSessionTemplate.insert("PhysicalRecord.insert", physicalRecord);
		if(result<1) throw new PhysicalRecordException("신체기록 등록 실패");
	}

	@Override
	public List<PhysicalRecord> selectPhysicalForMonth(Map<String, String> pysicalOneMonthPeriod) throws PhysicalRecordException{
		List<PhysicalRecord> physicalList=sqlSessionTemplate.selectList("PhysicalRecord.selectForMonth", pysicalOneMonthPeriod);
		if(physicalList==null)throw new PhysicalRecordException("신체기록 조회 실패");
		return physicalList;
	}
	
	

}
