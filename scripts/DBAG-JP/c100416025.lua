--ドレミコード・ムジカ

--Scripted by mallu11
function c100416025.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,100416025+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100416025.target)
	e1:SetOperation(c100416025.activate)
	c:RegisterEffect(e1)
end
function c100416025.scfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x265) and c:GetOriginalType()&TYPE_PENDULUM~=0
end
function c100416025.chkfilter(c,tp,odevity)
	if c:IsLocation(LOCATION_PZONE) and c==Duel.GetFieldCard(tp,LOCATION_PZONE,1) then
		return c:GetRightScale()%2==odevity
	else
		return c:GetLeftScale()%2==odevity
	end
end
function c100416025.spfilter(c,e,tp,odevity)
	return c:IsFaceup() and c:IsSetCard(0x265) and c:IsType(TYPE_PENDULUM) and c:GetLeftScale()%2==odevity
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c100416025.chkcon(g,e,tp,odevity)
	return g:IsExists(c100416025.chkfilter,1,nil,tp,odevity) and Duel.IsExistingMatchingCard(c100416025.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,odevity)
end
function c100416025.chkcon2(g,tp)
	return g:IsExists(c100416025.chkfilter,1,nil,tp,1) and g:IsExists(c100416025.chkfilter,1,nil,tp,0)
end
function c100416025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	local g=Duel.GetMatchingGroup(c100416025.scfilter,tp,LOCATION_ONFIELD,0,nil)
	local b1=c100416025.chkcon(g,e,tp,1)
	local b2=c100416025.chkcon(g,e,tp,0)
	local b3=c100416025.chkcon2(g,tp) and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local off=0
	local ops={}
	local opval={}
	off=1
	if b1 then
		ops[off]=aux.Stringid(100416025,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(100416025,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(100416025,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(opval[op])
	if opval[op]==1 or opval[op]==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c100416025.activate(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	if opt==1 or opt==2 then
		local sc=opt==1 and 1 or 0
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100416025.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sc)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
