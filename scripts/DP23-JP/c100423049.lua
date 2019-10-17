--ペンデュラム・ディメンション

--Scripted by mallu11
function c100423049.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c100423049.spcon)
	e2:SetTarget(c100423049.sptg)
	e2:SetOperation(c100423049.spop)
	c:RegisterEffect(e2)
end
function c100423049.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:GetMaterial():IsExists(Card.IsType,1,nil,TYPE_PENDULUM)
end
function c100423049.tgfilter1(c,e,tp,eg)
	return eg:IsContains(c) and c:IsFaceup() and c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(c100423049.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetOriginalLevel())
end
function c100423049.spfilter1(c,e,tp,lv)
	return c:GetOriginalLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100423049.tgfilter2(c,tp,eg)
	return eg:IsContains(c) and c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c100423049.spfilter2,tp,LOCATION_DECK,0,1,nil)
end
function c100423049.spfilter2(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function c100423049.tgfilter3(c,tp,eg)
	return eg:IsContains(c) and c:IsFaceup() and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c100423049.spfilter3,tp,LOCATION_DECK,0,1,nil,c:GetRank())
end
function c100423049.spfilter3(c,rank)
	return c:IsType(TYPE_TUNER) and c:GetLevel()<=rank and c:IsAbleToHand()
end
function c100423049.tgfilter4(c,e,tp,eg)
	return eg:IsContains(c) and c:IsFaceup() and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c100423049.spfilter4,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetRank())
end
function c100423049.spfilter4(c,e,tp,rank)
	return c:IsType(TYPE_TUNER) and c:GetLevel()<=rank and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100423049.spfilter5(c,e,tp,rank)
	return c:IsType(TYPE_TUNER) and c:GetLevel()<=rank and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c100423049.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and eg:IsExists(c100423049.cfilter,1,nil)
end
function c100423049.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mz=Duel.GetLocationCount(tp,LOCATION_MZONE)   
	local b1=Duel.GetFlagEffect(tp,100423049)==0 and Duel.IsExistingMatchingCard(c100423049.tgfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp,eg) and mz>0
	local b2=Duel.GetFlagEffect(tp,100423149)==0 and Duel.IsExistingMatchingCard(c100423049.tgfilter2,tp,LOCATION_MZONE,0,1,nil,tp,eg)
	local b3=Duel.GetFlagEffect(tp,100423249)==0 and (Duel.IsExistingMatchingCard(c100423049.tgfilter3,tp,LOCATION_MZONE,0,1,nil,tp,eg)
		or (Duel.IsExistingMatchingCard(c100423049.tgfilter4,tp,LOCATION_MZONE,0,1,nil,e,tp,eg) and mz>0))
	if chk==0 then return b1 or b2 or b3 end
	Duel.SetTargetCard(eg)
	if b1 or b3 then
		e:SetLabel(1)
		local cat=e:GetCategory()
		e:SetCategory(bit.bor(cat,CATEGORY_SPECIAL_SUMMON))
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
	if b2 or b3 then
		e:SetLabel(2)
		local cat=e:GetCategory()
		e:SetCategory(bit.bor(cat,CATEGORY_SEARCH+CATEGORY_TOHAND))
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if b3 then
		e:SetLabel(3)
	end
end
function c100423049.spop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local s=0
	local mz=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if op==1 then
		if Duel.GetFlagEffect(tp,100423049)~=0 then return end
		Duel.RegisterFlagEffect(tp,100423049,RESET_PHASE+PHASE_END,0,1)
		if mz<=0 then return end
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local lv=tc:GetOriginalLevel()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c100423049.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
			local gc=g:GetFirst()
			if gc and Duel.SpecialSummonStep(gc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				gc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				gc:RegisterEffect(e2,true)
				Duel.SpecialSummonComplete()
			end
		end
	end
	if op==2 then
		if Duel.GetFlagEffect(tp,100423149)~=0 then return end
		Duel.RegisterFlagEffect(tp,100423149,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c100423049.spfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if op==3 then
		if Duel.GetFlagEffect(tp,100423249)~=0 then return end
		Duel.RegisterFlagEffect(tp,100423249,RESET_PHASE+PHASE_END,0,1)
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local rank=tc:GetRank()
			if mz<=0 then
				local g=Duel.SelectMatchingCard(tp,c100423049.spfilter3,tp,LOCATION_DECK,0,1,1,nil,rank)
				if g:GetCount()>0 then
					local gc=g:GetFirst()
					e:SetLabelObject(gc)
					s=Duel.SelectOption(tp,1190)
				end
			else
				local g=Duel.SelectMatchingCard(tp,c100423049.spfilter5,tp,LOCATION_DECK,0,1,1,nil,e,tp,rank)
				if g:GetCount()>0 then
					local gc=g:GetFirst()
					e:SetLabelObject(gc)
					local b1=gc:IsAbleToHand()
					local b2=gc:IsCanBeSpecialSummoned(e,0,tp,false,false)
					if b1 and not b2 then
						s=Duel.SelectOption(tp,1190)
					end
					if not b1 and b2 then
						s=Duel.SelectOption(tp,1152)+1
					end
					if b1 and b2 then
						s=Duel.SelectOption(tp,1190,1152)
					end
				end
			end
			local gc=e:GetLabelObject()
			if s==0 then
				Duel.SendtoHand(gc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,gc)
			end
			if s==1 then
				Duel.SpecialSummon(gc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
