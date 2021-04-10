--人攻智能ME－PSY－YA

--Scripted by mallu11
function c101105024.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(c101105024.rmtarget)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	--check for Jowgen the Spiritualist
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(81674782)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetTargetRange(0xff,0xff)
	e0:SetTarget(aux.TRUE)
	c:RegisterEffect(e0)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105024,0))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101105024)
	e2:SetCost(c101105024.spcost)
	e2:SetTarget(c101105024.sptg)
	e2:SetOperation(c101105024.spop)
	c:RegisterEffect(e2)
	--chk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c101105024.chkop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--to graveyard
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101105024,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_CUSTOM+101105024)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c101105024.tgtg)
	e5:SetOperation(c101105024.tgop)
	c:RegisterEffect(e5)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e3:SetLabelObject(e5)
	e4:SetLabelObject(e5)
	e5:SetLabelObject(ng)
end
function c101105024.rmtarget(e,c)
	return c:GetOriginalType()&TYPE_MONSTER==0
end
function c101105024.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c101105024.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
end
function c101105024.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101105024.tefilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_HAND+LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101105024.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101105024,2))
	local g=Duel.SelectMatchingCard(tp,c101105024.tefilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,1,c)
	local tc=g:GetFirst()
	if tc and Duel.SendtoExtraP(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101105024.chkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetHandler()) then return end
	local ee=e:GetLabelObject()
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local tc=g:GetFirst()
	while tc do
		tc:CreateEffectRelation(ee)
		ee:GetLabelObject():AddCard(tc)
		tc=g:GetNext()
	end
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+101105024,e,0,tp,0,0)
end
function c101105024.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(101105124)==0 end
	c:RegisterFlagEffect(101105124,RESET_CHAIN,0,1)
	local g=e:GetLabelObject():Filter(Card.IsRelateToEffect,nil,e)
	e:GetLabelObject():Clear()
	Duel.SetTargetCard(g)
end
function c101105024.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(101105224,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(g)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c101105024.descon)
		e1:SetOperation(c101105024.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101105024.desfilter(c)
	return c:GetFlagEffect(101105224)~=0
end
function c101105024.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(c101105024.desfilter,1,nil)
end
function c101105024.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c101105024.desfilter,nil)
	Duel.SendtoGrave(tg,REASON_EFFECT)
	g:DeleteGroup()
end
