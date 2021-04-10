--魔键召龙-安托比姆斯
function c101105037.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c101105037.mtfilter,c101105037.mt2filter,true)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c101105037.valcheck)
	c:RegisterEffect(e0) 
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101105037.effcon2)
	e1:SetOperation(c101105037.spsumsuc)
	c:RegisterEffect(e1) 
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105037,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101105037.destg)
	e2:SetOperation(c101105037.desop)
	c:RegisterEffect(e2)
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101105037.drcon)
	e3:SetTarget(c101105037.drtg)
	e3:SetOperation(c101105037.drop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c101105037.matcon)
	e4:SetOperation(c101105037.matop)
	c:RegisterEffect(e4)
	e0:SetLabelObject(e4)
end
function c101105037.mtfilter(c)
	return c:IsSetCard(0x266) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT)
end
function c101105037.mt2filter(c)
	return c:IsType(TYPE_NORMAL) and not c:IsType(TYPE_TOKEN)
end
function c101105037.attfilter(c,rc)
	return c:GetAttribute()>0
end
function c101105037.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(c101105037.attfilter,nil,c)
	if #fg>0 and fg:GetClassCount(Card.GetAttribute) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c101105037.effcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101105037.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c101105037.chlimit)
end
function c101105037.chlimit(e,ep,tp)
	return tp==ep
end
function c101105037.ckfilter(c)
	return  (c:IsType(TYPE_NORMAL) or c:IsSetCard(0x266)) and Duel.IsExistingMatchingCard(c101105037.ckfilter2,tp,0,LOCATION_MZONE,1,nil,c:GetAttribute())
end
function c101105037.ckfilter2(c,at)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)   and  c:GetAttribute()&at~=0
end
function c101105037.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101105037.ckfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101105037.ckfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101105037.ckfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	local tg=Duel.GetMatchingGroup(c101105037.ckfilter2,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0) 
end
function c101105037.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c101105037.ckfilter2,tp,0,LOCATION_MZONE,1,nil,tc:GetAttribute())  then 
		local g=Duel.GetMatchingGroup(c101105037.ckfilter2,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c101105037.drfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,0,LOCATION_GRAVE,1,nil,c:GetAttribute())
end
function c101105037.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101105037.drfilter,1,nil,1-tp)
end
function c101105037.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c101105037.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101105037.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()==1
end
function c101105037.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(101105037,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101105037,2))
end